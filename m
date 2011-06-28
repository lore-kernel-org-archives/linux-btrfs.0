From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: parent transid verify failures on 2.6.39
Date: Tue, 28 Jun 2011 11:44:33 -0500
Message-ID: <BANLkTi=w4ZcVktZzwdKw7oszNvYyUoXjRA@mail.gmail.com>
References: <4E026FD4.7020606@podzimek.org>
	<1308793398-sup-9234@shiny>
	<20110623195409.GA21007@dhcp231-156.rdu.redhat.com>
	<4E03E8B8.9080500@podzimek.org>
	<loom.20110628T174243-342@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Daniel Witzel <dannyboy48888@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20110628T174243-342@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 28, 2011 at 10:46 AM, Daniel Witzel <dannyboy48888@gmail.com> wrote:
> Earlier I tried the read only patch with no result. Josef said I must be
> applying it wrong because the error I get is not possible with the patch applied.
> I tried again with no luck and posted my steps for review. Well here I am a few
> days later with the following questions:
>
> 1) If my steps are correct what else could be the problem
> 2) if my steps are wrong what do i need to do to get it right
>
> Any help would be awesome
>
> Thanks
> Dan Witzel
>

I just used this patch yesterday to help with a slightly different corruption.

I know the patch didn't apply cleanly for me, and I had to massage it.

You may want to manually audit disk-io.c to make sure the entire patch
is applied.

I know if I try to apply this patch to my 2.6.39.1 kernel, it fails.

# patch -p1 --dry-run <
/mnt/local/local/dontpanic/parent-transid-verify-failures-on-2.6.39.patch
patching file fs/btrfs/disk-io.c
Hunk #2 FAILED at 296.
Hunk #3 succeeded at 321 (offset -2 lines).
Hunk #4 succeeded at 331 (offset -2 lines).
Hunk #5 succeeded at 353 (offset -2 lines).
Hunk #6 succeeded at 1993 (offset -14 lines).
Hunk #7 succeeded at 2629 (offset 3 lines).
1 out of 7 hunks FAILED -- saving rejects to file fs/btrfs/disk-io.c.rej
