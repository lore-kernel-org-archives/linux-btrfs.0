Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:38477 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1755152AbcIFRxU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Sep 2016 13:53:20 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1bhKYb-0007MH-2L
        for linux-btrfs@vger.kernel.org; Tue, 06 Sep 2016 19:53:13 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [OT] ccache and tmpfs builds Was: Balancing subvolume on a
 specific device
Date: Tue, 6 Sep 2016 17:53:06 +0000 (UTC)
Message-ID: <pan$61e17$eb30f82d$a4aee2d7$72847bb2@cox.net>
References: <df03a71c-8558-520c-af1b-ffb152f65a7d@davideddu.org>
        <20160819171734.GJ20440@carfax.org.uk>
        <pan$dbf6f$52e9f6f3$42f8cce4$2ebbbbc6@cox.net>
        <20160901214519.79d27445@jupiter.sol.kaishome.de>
        <pan$97e1b$477b3a63$5742ac9b$a63fe8a6@cox.net>
        <ba97bb60-7b59-9fe0-b255-a39c6ab4e420@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn posted on Tue, 06 Sep 2016 08:32:02 -0400 as
excerpted:

> On 2016-09-02 06:55, Duncan wrote:
>> Kai Krakow posted on Thu, 01 Sep 2016 21:45:19 +0200 as excerpted:
>>
>>> Off topic: Is ccache really that helpful? I dumped it a few years ago

>>> What would help a whole lot more would be to cache this really really
>>> inefficient configure tool of hell which often runs much longer than
>>> the build phase of the whole source itself.
>>
>> IDK if you were around back then, but some time ago there was a
>> confcache project that tried to do just that.  But unfortunately, it
>> was enough of a niche use-case (most folks just run binary distros and
>> don't care, and others have switched to cmake or the like and don't
>> care) and came with enough problem corner-cases that required upstream
>> cooperation that wasn't coming as they didn't care, to fix, that the
>> project was eventually given up.  =:^(

> Alternatively, there's a mechanism (I think it's called something like
> config.local) that lets you pre-load certain things in the configure
> script.  Some things aren't safe to load here, but many package
> invariant things (like if you have working headers, or how malloc(0)
> returns, or similar things that are never going to change unless you
> change your CHOST) can be put here.  I don't know how much it may help
> speed things up (I don't use it right now myself), but it may be worth
> trying.

Good point.  I'm not far enough to the developer side to know the 
details, but IIRC confcache actually worked by prepopulating 
config.local, thereby bypassing various tests where the result was 
already cached.  The problem was, however, that there were too many 
corner-cases that should have invalidated the cache or part of it that 
were too hard to catch reliably, making it a maintainability nightmare as 
code was added to take care of all these corner-cases.  I strongly 
believe that's what ultimately did the project in.  Well, that and the 
primary guy behind it graduating or whatever and moving on, I think, but 
it made enough difference that were it /easy/ to maintain, someone would 
have definitely done so.

[On parallel builds as a work-around]

> Pretty much the same here, I just don't use parallel builds ATM (I've
> had lots of ebuild bugs hit me recently, and it's a bit easier to debug
> such things if everything is serialized)

I've pretty much gone the other way.  Parallel by default (I have 
scriptlets that handle the emerge commandline details and all the default 
ones add the --jobs and --load-average options), but with builds in tmpfs 
and ccache, when something fails, 90%+ of the time I simply rebuild it 
individually instead of finding the log.  In fact, with the defaults 
including continue as well, so portage continues on to build other 
packages even if one fails, most of the time it's continuing on after 
I've caught the failed build and am rerunning it in a different terminal 
window with full output to the terminal.

Say there's 50 packages to update and #13 fails.  But by the time it 
fails 14-16 are already building and complete just fine, and while it 
won't schedule any new builds after a failure until it recalculates the 
build graph and removes deps of the failed, once it does that it 
continues on.  So in our example original #20 and 21 are dropped as 
reverse deps of the failed, but of the first 16, 15 succeeded and one 
failed, and of the entire 50, two more are dropped.  After the 
recalulation it then has (original) #17-19 and 22-50 to build.  So then 
it starts the recalculated set with 32 (if I did my math right), and 
continues building from there.

But by this time I've noticed the failed #13 and set it rebuilding with 
output to a different terminal.  Because of the load-average limits that 
simply slows up the continuing rebuild of the 32 a bit, but with the 
builds in tmpfs, the rebuild now ccached, and the rebuild's reads all in 
system cache, the rebuild will go quite fast even with a heavy load from 
the continuing build in the other terminal, and it's simply easier to 
redo the single failed build and get the log on-terminal this time, than 
it is to load the failed build log in a text editor.

So I rebuild the failed one by itself, and sometimes it'll build fine the 
second time around -- maybe it was just an undeclared dep that's built 
now or something.  (Since I'm running live-git kde, sometimes those live-
build deps in particular have changed and it simply hasn't been reflected 
in the ebuild yet.)

Or with a live-git package sometimes the dev has already caught and fixed 
the problem and a rebuild "just works".

Or it may be something easily solved by a simple patch, often quickly 
googled from bugzie or whatever, that I can simply drop in /etc/portage/
patches, and again rebuild.  Or I can bypass the problem with a quick 
entry in package.use or package.env.

In these cases I'll often have the problem solved and the package and any 
reverse deps that dropped out of the automatic build due to the failure, 
manually rebuilt or well on the way, before the rest of those 32 packages 
in the automatic rebuild have finished.

Of course if it's something like qtwebkit, that takes "forever" to build, 
I'll sometimes just look at the log file rather than just restarting the 
build to get a live log.  But most of the time it's just easier to do the 
manual rebuild with the live-log to terminal, and see what failed (and if 
it was just a temp failure that's already fixed) that way.  Let the multi-
core cpu and build in tmpfs do the grunt work, while I focus on fixing 
the real problems instead of bothering with tab completion to get the 
log.  That's what I bought both the cpu and extra memory for, after all.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

