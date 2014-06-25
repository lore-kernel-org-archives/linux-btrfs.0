Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:42828 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbaFYFyN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jun 2014 01:54:13 -0400
Received: by mail-qa0-f53.google.com with SMTP id j15so1121824qaq.26
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Jun 2014 22:54:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9C02AC8A-68FE-4344-A59B-7580D9E0D0C5@colorremedies.com>
References: <CAB=7dhnnfr_5bpkD5k29f0xHHMbyUy8EXPsE6RC3r=JgPbE7Gw@mail.gmail.com>
 <ECEE7DFB-E4E1-482D-929F-ABAF8133E1F4@colorremedies.com> <CAB=7dhk-HM-uT891yKo3-XO2Ko_eC7=qNkLrV_4uM_UmOR1Rmg@mail.gmail.com>
 <144BDE55-B4B9-405A-B106-F7681FBAF761@colorremedies.com> <CAB=7dhms_ehP4y+L_tMBrdUnJiwXAOn7E4Fa9u3euVBwBKHOKA@mail.gmail.com>
 <27F042E8-CC94-497D-96B7-283AA1CBD296@colorremedies.com> <CAB=7dh=yq-KjtHOjKPncvGziCEiJgVyMiAAY=4w=Za0Sr9geAg@mail.gmail.com>
 <9C02AC8A-68FE-4344-A59B-7580D9E0D0C5@colorremedies.com>
From: Mike Hartman <mike@hartmanipulation.com>
Date: Wed, 25 Jun 2014 01:53:52 -0400
Message-ID: <CAB=7dhkRURCdaSjYvJfKUecfVt_q+_q26yyEpo2w9Wp1echLjQ@mail.gmail.com>
Subject: Re: Btrfs suddenly unmountable, open_ctree failed
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Does this version's btrfs-image allow you to make an image of the file system?

Nope, same errors and no output.

> https://btrfs.wiki.kernel.org/index.php/Restore
>
> Your superblocks are good according to btrfs rescue super-recover. And various tree roots are found by btrfs-find-root including a tree root that also matches the latest latest generation:
>         * Super think's the tree root is at 763420672, chunk root 20971520
>         * Found tree root at 763420672 gen 214454 level 1
>
> And yet btrfs restore fails. I'm not sure why but try:
>
> btrfs restore -t 763420672 /dev/mapper/sda6_crypt /media/mint/usb_data/sda6_btrfs_recovery/
>

First of all, a new log of all my restore attempts is here:
http://pastebin.com/7QcNMahG

This gives me the same output as omitting the -t parameter. (Which it
should since that's the root it detects on its own.)

> If that command doesn't quickly fail or spit out a bunch of messages, then it's probably restoring files. If you confirm in another shell that it is restoring, cancel the restore, and then figure out how to use the --path-regex option with the above command to just get the files you're looking for. If it fails, consider -i to ignore errors. Hopefully any errors stopping restore won't apply to the files you're looking for.
>

Adding -i gets it a bit further. It doesn't quit when the @home volume
throws an error. It proceeds to try the @ volume, which also throws an
error. And then it mentions that it's skipping the snapshots since I
didn't specify -s:

.....
read block failed check_tree_block
Error reading subvolume
/media/mint/usb_data/sda6_btrfs_restore_t_763420672/@home:
18446744073709551611
Check tree block failed, want=756572160, have=6711487709046970189
Check tree block failed, want=756572160, have=6711487709046970189
Check tree block failed, want=756572160, have=5305625995405044180
Check tree block failed, want=756572160, have=5305625995405044180
Check tree block failed, want=756572160, have=5305625995405044180
read block failed check_tree_block
Error reading subvolume
/media/mint/usb_data/sda6_btrfs_restore_t_763420672/@:
18446744073709551611
Skipping snapshot @_2014-05-22_pre-Firefox-29-upgrade
Skipping snapshot @home_2014-05-22_pre-Firefox-29-upgrade
Skipping snapshot @_2014-05-29-pre-Add-Intel-Graphics-Repo

> If this still fails, then go back up one generation in your btrfs-find-root list and use that tree root:
> btrfs restore -t 762122240 -i --path-regex '<blah>' /dev/mapper/sda6_crypt /media/mint/usb_data/sda6_btrfs_recovery/
>
> And so on up the list. Maybe one of them will work (?).

Tried them all, but none worked. They all gave the same error, except
the generation varied:

parent transid verify failed on 761872384 wanted 214454 found 214447
parent transid verify failed on 761872384 wanted 214454 found 214447
parent transid verify failed on 761872384 wanted 214454 found 214447
parent transid verify failed on 761872384 wanted 214454 found 214447
Ignoring transid failure
Couldn't setup extent tree
Couldn't setup device tree
Couldn't read fs root: -2

It seems like even though I'm explicitly telling it to use tree X
which is generation Y, it's failing because the generation isn't the Z
it expects. Which seems odd, because if you're passing the -t
parameter it's because you specifically DON'T want the most recent
tree. In which case the generation of the -t you specify will never
match the generation it's looking for. If it really does work that way
(generation of the tree you specify must match the generation it
thinks the system should be on) I don't see how the -t option could
ever work at all.

Anyway, I DID have some luck with "-is". It still refuses to load the
current state of the volumes, but it's able to recover a lot of stuff
from the 3 snapshots I have in there. Unfortunately, the recent
content I'm most interested in rescuing is in @home, and the only
snapshot I have of that is several weeks older than that content. I
usually only snapshot the root when I'm upgrading something or making
other system changes.

To be clear, I have two goals:

    - Retrieve an intact version of @ with as few errors as possible,
even if it's quite old. This is my / partition, and if I can get it
back on the drive I'll have a working system again. I can always
re-upgrade/install whatever I've touched in the last few weeks. I
think what I retrieved from the snapshots should suffice for this,
assuming there's not too much missing.

    - Retrieve as much of @home from the last week as possible. This
can tolerate more errors than @ since it's mostly data files, but the
data I'm looking for is also more recent.

> I think you're in #btrfs channel on freenode territory. Try the above, and if all fail, head to #btrfs.

I think that's the point I'm at with the @home retrieval. I've got the
dd image, those files aren't going anywhere and I don't need them
immediately. I will see if anyone in #btrfs can help. (Although if
anyone on the list has further ideas, please chime in! I'm listening.)

I do have a few more questions about how to leverage my recovered
snapshots into a working root though.

- Most of the output from "-isvvv" consists of "Restoring..." lines
for various files it was able to recover. But I have 4264 lines that
just look like "offset is <some number>". Do those represent files
that should be there that it couldn't retrieve? Some other error? I'm
trying to get a sense of what might be missing.

- The output shows files that were recovered and (I assume this is
what the "offset" lines are) recovery attempts that failed. Is there
any possibility there were other files in there that it just plain
didn't detect in the tree at all, so that it wouldn't even throw an
error for them? Or does the fact that the tree is obviously intact
enough to traverse rule that out? Again, trying to get a sense of how
complete the recovery was.

- Assuming I have a directory that represents an intact @ (whether
it's a single one of the snapshots or a merged version of both of them
to fill in missing files) how would I go about getting that back on
the original drive so I can boot into it? Would I just
delete/overwrite the existing btrfs fs on sda6, create a btrfs fs with
@ and @home volumes from scratch, and then just copy my directory onto
@?

Thanks for all the help.
