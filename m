From: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>
Subject: Re: Determine if a given fs is a btrfs fs
Date: Mon, 25 Oct 2010 07:31:16 -0400
Message-ID: <AANLkTina9g610_FLHHsOG3KSn5pgeiHCgaNtE7NnvH7g@mail.gmail.com>
References: <20101024202410.GA2830@scooter>
	<AANLkTikB06jNR-QmkXjWWFE6fO=cTZvEDFbY5V98Pu6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikB06jNR-QmkXjWWFE6fO=cTZvEDFbY5V98Pu6g@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Oct 24, 2010 at 5:32 PM, J=E9r=F4me Poulin <jeromepoulin@gmail.=
com> wrote:
=2E..
> p4 jerome # btrfs device scan /dev/dm-22
> Scanning for Btrfs filesystems in '/dev/dm-22'
> p4 jerome # echo $?
> 0
This is OK.

> p4 jerome # btrfs device scan /dev/sda
> Scanning for Btrfs filesystems in '/dev/sda'
> ERROR: unable to scan the device '/dev/sda'
> p4 jerome # echo $?
> 11
=2E..
But isn't that error misleading, btrfs scan was succesfully able to
scan /dev/sda, but, it doesn't contain btrfs, right?
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
