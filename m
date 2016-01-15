Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42260 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757174AbcAOMS6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jan 2016 07:18:58 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aK3L9-0003o8-NW
	for linux-btrfs@vger.kernel.org; Fri, 15 Jan 2016 13:18:51 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Jan 2016 13:18:51 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Jan 2016 13:18:51 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Query about proposed dedup patches and behaviours
Date: Fri, 15 Jan 2016 12:18:46 +0000 (UTC)
Message-ID: <pan$5ad99$de23f375$ce80d2dd$892b7fc5@cox.net>
References: <CAGkb5vfzcOmj1Js=pBR6=-Uad7jY2bJy5ht3F-m-1TEOBjwCYA@mail.gmail.com>
	<5697D0E9.3080007@gmail.com>
	<20160114192647.GB24567@localhost.localdomain>
	<5697F9E7.1020004@gmail.com>
	<pan$b0586$d2b2b229$291cbb7b$f3802e23@cox.net>
	<CAGkb5vdQU6z0SaMAW+WHTNxdKj8L0mdDe6zOyByzYLiK=CKfsw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

James Hogarth posted on Fri, 15 Jan 2016 09:33:44 +0000 as excerpted:

> On 15 January 2016 at 01:47, Duncan <1i5t5.duncan@cox.net> wrote:
>>
>> Hugo should really explain as he was the one that said that, but 
>> [...]  In general, autodefrag remains bad for reflinks, but
>> apparently not h***-bad, as manual defrag is.
>>
> As I recall it's something like autodefrag will break the reflink pretty
> much to the same extent as if you just starting writing to each
> instance.
> 
> http://article.gmane.org/gmane.comp.file-systems.btrfs/51441

That's it, yes.  Thanks.  =:^)

I think I had read it but hadn't actually explained it to anyone myself 
yet, which tends to solidify it in my mind, so forgot enough of the 
detail that I couldn't easily do so.  Let's see if the below explanation 
solves that for next time.  =:^)

Tho just writing to the file would normally only copy the 4096-byte 
block, while autodefrag will check how fragmented the file is around that 
block, and if the extents are small enough to trigger a defrag, it'll 
rewrite rather more of the file into a (hopefully) larger single extent.

So autodefrag will break reflinks to a rather larger extent (literally, 
file extent) than will writing to an individual block within a file, but 
(on a reasonably large file, say 100-MiB scale) it should still be a much 
smaller effect (breaking reflinks for a rather smaller part of the file) 
than defragging the entire file, which is what a manual defrag would do.

And as Hugo said, of course if you're rewriting most of the file, it's 
likely all or almost all the file will be reflink-broken, but that would 
be expected anyway, if you're rewriting the file.

So as I said, autodefrag is a bit bad for reflinks, yes, but not h***-bad 
for them, as manual defrag is.


> It does appear that btrfs-progs is only being extended to enable or
> disable dedup on a whole pool rather than to dedup X files

> So I see two things out of this:
> 
> 1) A least a note in the man page (or command output as well preferably)
> reminding that autodefrag will to an extent work against dedupe (and it
> may be worth testing the effect of both enabled and if poor preventing
> one whilst the other is there).

Agreed, a manpage (and wiki mount options page) note explaining that 
autodefrag can partially undo dedup's work, would be useful.

> 2) Qu is there any intention to be able to do btrfs dedup /path1../pathN
> or is the intention for this work only to enable in-band across an
> entire pool (less any files with the proposed attribute changed to say
> nodedup)?
> 
> If there is no intention for 2 then the duperemove packaging is still
> worthwhile to carry out.

Previous discussion has made plain that this is /inline/ dedup, write new 
data, and it's compared against existing data (hashes or the like) to see 
if part or all of it can be reflinked instead of written separately.

And while not yet part of the patches, a per-file nodedup property is 
intended as well, which if set, will mean the file isn't included as 
existing data when the comparison of new data against existing data is 
made.

As such, there will indeed be no way to specifically dedup one already 
existing file against another (unless of course you rewrite it, 
triggering the inline dedup), which is precisely where (separate) out-of-
line dedup comes in.

So yes, dupremove, as one option for that separate out-of-line dedup, 
will still be worthwhile, with the two functionalities complimenting each 
other.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

