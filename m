Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60249 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757658Ab2FYWef convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jun 2012 18:34:35 -0400
Received: by obbuo13 with SMTP id uo13so7079611obb.19
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Jun 2012 15:34:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FE8A3D9.3060400@zytor.com>
References: <4FE1F9E4.5090301@zytor.com>
	<CAAdM646jbr3+5stVTkX=E2Rb2SVWoMKyptr4Bv5g5-6O_6Uq4g@mail.gmail.com>
	<20120621005048.GA19507@shiny>
	<670f2f56-9918-4463-ad89-780ba80bfecc@email.android.com>
	<20120625152142.GD17638@shiny>
	<4FE8A3D9.3060400@zytor.com>
Date: Tue, 26 Jun 2012 08:34:35 +1000
Message-ID: <CA+WRLO9JFM7rL2ijZDiq7DkmLxPqeQg9T_pLmQV1MVb1wavMdQ@mail.gmail.com>
Subject: Re: Feature request: true RAID-1 mode
From: Gareth Pye <gareth@cerberos.id.au>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 26, 2012 at 3:46 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> On 06/25/2012 08:21 AM, Chris Mason wrote:
> > Yes and no.  If you have 2 drives and you add one more, we can make it
> > do all new chunks over 3 drives.  But, turning the existing double
> > mirror chunks into a triple mirror requires a balance.
> >
> > -chris
>
> So trigger one.  This is the exact analogue to the resync pass that is
> required in classic RAID after adding new media.
>
>        -hpa
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

To me one doesn't have to be triggered, a user expects to have to tell
the disks to rebuild/resync/balance after adding a disk, they may want
to wait till they've added all 4 disks and run a few extra commands
before they run the rebalance. What is important is having a mode that
doesn't require the user to remember that what they had used as the
closest analogue to RAID1 that BTRFS supports requires them to run
another command to change the 'RAID level' to be the RAID1 analogue
for the new number of disks.

Users will forget that and they will lose data because of it. At least
with a M=N mode BTRFS can say they tried to make it easy to avoid that
pitfall.

(resend in plain text for mailing list, CC list received the HTML version)

--
Gareth Pye
Level 2 Judge, Melbourne, Australia
Australian MTG Forum: mtgau.com
gareth@cerberos.id.au - www.rockpaperdynamite.wordpress.com
"Dear God, I would like to file a bug report"
