Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from postler.lichtfels.com ([78.46.92.195]:54378 "EHLO
	postler.lichtfels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172AbaIPVOn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Sep 2014 17:14:43 -0400
Message-ID: <5418A6B9.6090003@xunil.at>
Date: Tue, 16 Sep 2014 23:08:09 +0200
From: "Stefan G. Weichinger" <lists@xunil.at>
Reply-To: lists@xunil.at
MIME-Version: 1.0
To: Anand Jain <Anand.Jain@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Unable to mount multiple subvolumes of a single disk
References: <5417022A.5000101@codethink.co.uk> <54170BCA.7070900@fb.com> <54170F35.4040103@oracle.com> <54171E51.2020709@codethink.co.uk> <54172018.1050300@oracle.com> <5417250B.9030105@oracle.com>
In-Reply-To: <5417250B.9030105@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 15.09.2014 um 19:42 schrieb Anand Jain:

> Sam,
> 
>   In the above context, Can you pls share the btrfs fi show output ?


unsure if it helps:

I applied the patch as well, running gentoo on latest git-sources here.

My "btrfs fi show" misses my SSD now:

# btrfs fi show
Label: 'btrfs_evo'  uuid: ea95dbd1-ef4e-48a4-9732-54e6c80b31df
	Total devices 1 FS bytes used 80.91GiB
	*** Some devices missing

.. although all the btrfs-subvols on /dev/sda2 are mounted correctly and
everything works fine so far.

Stefan

