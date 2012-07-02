Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51214 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab2GBLso (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Jul 2012 07:48:44 -0400
Received: by obbuo13 with SMTP id uo13so8105429obb.19
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Jul 2012 04:48:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120627134633.GA2819@localhost.localdomain>
References: <CAHf9xvafQugP2c_3_rxNAn55TgF_GiCM7udNS6yLEqVfPD1_wg@mail.gmail.com>
	<20120625192632.GF7404@localhost.localdomain>
	<CAHf9xvYGWvOCCUUte8Y29RG+G0aXAbKkE3up7r=2SDRLCRQKwg@mail.gmail.com>
	<CAHf9xvb2iGtyBY_28JexHa4w==Haiy4BN_e0qc2Df6Q+rBG98Q@mail.gmail.com>
	<20120627134633.GA2819@localhost.localdomain>
Date: Mon, 2 Jul 2012 14:48:43 +0300
Message-ID: <CAHf9xvY7eoDA6BSAwz+-Nbn0hzC89N5EPS-KJ=qXfvyJ2q2b5A@mail.gmail.com>
Subject: Re: fio reports data corruption with btrfs
From: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,
which branch from your (or another?) repo should I try this on:

remotes/origin/HEAD      -> origin/master
remotes/origin/enospc    3c78455 Btrfs: fall back to non-inline if we
don't have enough space
remotes/origin/for-chris 7e9ce65 Btrfs: hold a ref on the inode during
writepages
remotes/origin/master    1573317 Btrfs: use helper function to simplify code

Thanks,
Alex.



On Wed, Jun 27, 2012 at 4:46 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> On Wed, Jun 27, 2012 at 02:15:59AM -0600, Alex Lyakas wrote:
>> Hi Josef,
>> I have rerun the test with btrfs-next master branch. fio reported
>> mismatched blocks again. Mount options were the same (-o
>> noatime,nodatacow).
>>
>
> Ok I'll try running it again here locally, I didn't realize it was nodatacow.
> In the meantime can you try a newer version of fio, I'm running
> fio-2.0.6-1.fc18.x86_64 but I think git is even newer than that.  Thanks,
>
> Josef
