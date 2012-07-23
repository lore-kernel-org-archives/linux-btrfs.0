Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:36353 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab2GWEza convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Jul 2012 00:55:30 -0400
Message-ID: <500CD93E.9040207@petaramesh.org>
Date: Mon, 23 Jul 2012 06:55:26 +0200
From: =?UTF-8?B?U3fDom1pIFBldGFyYW1lc2g=?= <swami@petaramesh.org>
MIME-Version: 1.0
To: Roman Mamedov <rm@romanrm.ru>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Change "small" filesystem to normal
References: <500C16F0.6000205@petaramesh.org> <20120722213714.2b5be0e1@natsu>
In-Reply-To: <20120722213714.2b5be0e1@natsu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

You're painfully right Roman,

A freshly formatted 1 GB BTRFS filesystem on which 81 MB of data has 
been put shows only ~260 MB of free space and reserves something like 2 
x 380 MB of metadata.

This is absolutely ridiculous of BTRFS... :-/

Kind regards.


Le 22/07/2012 17:37, Roman Mamedov a écrit :
> On Sun, 22 Jul 2012 17:06:24 +0200
> Swâmi Petaramesh <swami@petaramesh.org> wrote:
>
>> Hi,
>>
>> I've created a "small" BTRFS filesystem, where metadata+data are mixed
>> (and metadata are not DUP'ed).
>>
>> Then I've enlarged the FS to 1 GB ; now I'd like to make it "normal"
>> with separate data and metadata, and "DUP'ed" metadata.
> Considering the metadata overallocation bug [1] is still not fixed even in the
> latest kernels and no one seems to care all that much, I would not recommend
> doing that.
>
> Personally I now use a "mixed" filesystem on a 1TB disk without any problems,
> and do not think there's anything wrong with "mixed". In fact there's been
> some talk of moving to the mixed mode allocation to be used by default, and
> maybe even removing support for the "split" mode: see [2].
>
> [1] http://comments.gmane.org/gmane.comp.file-systems.btrfs/17848
>
> [2] http://kerneltrap.org/mailarchive/linux-btrfs/2010/10/29/6885925
>
>

