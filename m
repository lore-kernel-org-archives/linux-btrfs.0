Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from phd-imap.ethz.ch ([129.132.80.51]:48488 "EHLO phd-imap.ethz.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750954AbdBUI3P (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Feb 2017 03:29:15 -0500
Subject: Re: mount troubles after crash
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <756b50f6-5cd7-dd5c-f180-4f5347c7f8ee@phys.ethz.ch>
 <bd53a4db-c07a-3fd5-55af-9ed2a5d17d61@cn.fujitsu.com>
From: Patrick Schmid <schmid@phys.ethz.ch>
Message-ID: <df407f9c-fb1b-804f-4e43-85b38c590fb8@phys.ethz.ch>
Date: Tue, 21 Feb 2017 09:29:12 +0100
MIME-Version: 1.0
In-Reply-To: <bd53a4db-c07a-3fd5-55af-9ed2a5d17d61@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Qu

> A known bug when qgroup is enabled.
> Fixed in v4.10-rcs.
>
> Please mount using v4.10 kernels and it will mount without problem.

I have rebootet with the v4.10 kernel and everything works again!
Thank you very much, you save me a lot of work!

Regards Patrick
--
Patrick Schmid  <schmid@phys.ethz.ch>     support: +41 44 633 2668
IT Services Group, HPT H 8                voice:   +41 44 633 3997
Departement Physik, ETH Zurich
CH-8093 Zurich, Switzerland
