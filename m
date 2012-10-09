Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:59761 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410Ab2JIWPX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Oct 2012 18:15:23 -0400
Date: Wed, 10 Oct 2012 00:15:08 +0200
From: David Sterba <dave@jikos.cz>
To: Goffredo Baroncelli <kreijack@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Bart Noordervliet <bart@noordervliet.net>,
        Chris Mason <chris.mason@fusionio.com>,
        Hugo Mills <hugo@carfax.org.uk>, Roman Mamedov <rm@romanrm.ru>,
        =?iso-8859-1?Q?S=E9bastien?= Maury <sebastien.maury@inserm.fr>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: Re: [PATCH][BTRFS-PROGS][V3] btrfs filesystem df
Message-ID: <20121009221508.GX4405@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1349371679-10775-1-git-send-email-kreijack@inwind.com>
 <20121009135138.GP4405@twin.jikos.cz>
 <507467F7.1090907@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <507467F7.1090907@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 09, 2012 at 08:07:51PM +0200, Goffredo Baroncelli wrote:
> There was several emails about this topic. At the end we find more logical
> to avoid the options. See the thread "[PATCH][BTRFS-PROGS][V3] btrfs
> filesystem df" for the reasons.

I had read all the threads before I responded to the latest version.
Lack of the s/d options hurts usability and flexibility when poeple have
various expectations and practices, that's my concern. And we've seen
different oppinions, we should listen to them.

> >UI details (that make human-parsing of the output more pleasant experience):
> >
> >* the 'Path' should contain full path, not just the argument that was
> >   given (otherwise it's useless)
> The reason to put the path in the output is to disambiguation of the
> sections when multiple paths are passed. It was not intended to identify the
> absolute path of an argument.

Ok, I never used df with multiple paths, I can live with the path that's
passed on the commandline.

> >* I'm with Hugo that there should be space between numbers and units
> I already replayed to Hugo about that: this issue is note related to my
> patches. I used the function "pretty_sizes()", which was made at the
> beginning of the btrfs-progs. I don't want to address your concerns (which
> are  be valid) in this set of patches.

You've picked the taks to improve df output and now you're stopping to
do that for a reason I do not understand -- you're always changing code
that was there from the beginning. Is it some kind of monument we're not
allowed to touch?

> Also because the question is not so simple: Bart suggested to used the the
> SI units (pow of ten) instead the IEC unit (pow of 2); or better we could
> let the user to select different unit....

Yes exactly. Bart had a valid comment, we should listen to the users.

> >* show the byte units
> At the beginning it was so. But the space required was greater than 80
> columns. Moreover the allocation space is in multiply of 4KiB, so showing
> the number in bytes doesn't add any information. The documentation clearly
> stated that if -k is passed the units are KiB.

Keeping the line at most 80 sounds reasonable, but if the overflow is
only because of 4x ' ' or units, we can try to squeeze the empty space
between columns.

> >* the short form for metadata in --mixed filesystem
> >   current:  Data+M.data
> >   proposed: Data+Meta
> I like your proposal, but at this point I don't want to add another
> iteration on this topic until other people ack your proposal.

Fair enough.

> >* Chunk_type ->  Type ?
> There was another person who made the same proposal. However I don't like
> it: what mean "type" alone ? We are showing the chunk information.

And the person said "what does chunk mean to the user? it's an
internal detail." (IIRC). There's also 'type' for the raid profiles,
ambiguity of the term 'type' will lead us to confusion when we'll talk
to users. The term 'profile' is AFAIK widely used in the context of
RAIDs.

> >* Size_(logical) is misaligned with the numbers underneath
> It is not an error. I did so because the constraint of 80 column when the
> unit is set to KiB. Otherwise I have to maintain two completely set of
> printf depending by the unit used.
> But I have to agree to the fact that it is not very pleasant to read.

Let's fix it.

> >* Used (in the summary) is in logical units, I needed to hand calculate
[snip]
> I am not against to change but I would like to see other
> people to support your suggestion.
> 
> >* revert the order of Min and Max in Free_(Estimated)
[snip]
> What this the reasons ? I don't find Max..Min more (or less) reasonable than
> Min..Max. Again, I am not against your request but I would like to see other
> people support your suggestion.

Seems that the only way I can get possitive/negative feedback on those
suggestions is after I send a patch that implements them.

> >* in code: function is still named cmd_disk_free
> This was already discussed. The reason behind that was that this function is
> not an update of the old one, but a new one. Then the diff program collapse
> the two changes (removing the old one and adding the new one). There is no
> reason to maintain the same name. Several commands also have a name
> different from "its cmd-line name".

The function names match the command names 90% of the commands. The
exceptions are cmd_rm_dev and cmd_inspect.

> I maintained df as per Chris request; originally I wanted to call it
> disk-usage. I renamed the function disk_usage to disk_free as compromise. My
> opinion is that df should renamed disk-free....

Too long to type, this is a frequent command and part of people's habit,
I'm completely with Chis here.

> >Also, I've noticed that you refuse to fix minor things in code that
> >you're not touching directly for 'df', but this renders the (much
> >needed!) updates to df as only half-finished (IMHO).
> 
> Frankly speaking it is a bit un-polite to declare our work (the my one and
> the the ones of the reviewers) to be "half finished". Moreover you raised a
> lot of requests with very few explanations.

Do you really think it's finished? I don't want to be impolite, I don't
use insults or strong words. Dictionary defines 'half-finished' as
'partially completed'.

I try to explain the reasons and if I fail to, please ask again. I'm
your yet another reviewer, not your enemy. The other reviewers may
likewise feel offended by your lack of interest to include their
proposals.

I try to explain my reasons and this costs me time and energy in hope
that the efforts will be worth for the project.

> I can live with the fact that you don't like my work, but if you want to
> improve the situation you should justify your requests for respect of other
> peoples.

This is diverging from the process of proposing patchsets and doing the
review rounds, I'm not taking any personal fights over code. The 'df' is
a highly visible command and I'm paying extra attention to that we end
up with.

I base my requests on my own experience, feeling, and on feedback from
users on IRC or my colleagues. I respect users and developers, trying to
find a reasonable middle ground. That's not easy and very likely not
resolved on the first attempt.

> Pay attention that every loop requires time (which is not infinite) so at
> the end we should balance the needing of improvement (everything could be
> improved) with the needing of the patch.

I'm well aware of peculiarities of pushing patches upstream.  Sure,
we're all busy, I had to reschedule my spare time projects because I
don't want to miss the 'df' changes.


david
