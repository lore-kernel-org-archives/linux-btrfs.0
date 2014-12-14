Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-03v.sys.comcast.net ([69.252.207.35]:46076 "EHLO
	resqmta-ch2-03v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750766AbaLNHiH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Dec 2014 02:38:07 -0500
Message-ID: <548D3E59.4010005@pobox.com>
Date: Sat, 13 Dec 2014 23:38:01 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Ali AlipourR <alipoor90@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: subvolume / folder compression flag
References: <CABvhJLiV4iPkin_XU-Ud3a0KiOLNv07m6whqZtNymDQd+1WHGw@mail.gmail.com>
In-Reply-To: <CABvhJLiV4iPkin_XU-Ud3a0KiOLNv07m6whqZtNymDQd+1WHGw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/13/2014 06:59 PM, Ali AlipourR wrote:

> 2- ... and rsync files without compression flag ...

The --compress flag for rsync has nothing to do with how the files are 
stored on either end. It determines whether the data is compressed as it 
passes from the source rsync to the destination rsync process over the 
network or whatever.

I don't have any information about the rest of the question but the 
rsync option doesn't change the data as read or written, just as 
transmitted.

The only difference between using compressed or not is:

source --normal--> rsync --compressed--> rsync --normal--> dst
source --normal--> rsync --not_compressed--> rsync --normal--> dst

If the fielsystems at source or dst do transparent compression then that 
will be done/undone transparently.


