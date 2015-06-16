Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx.bordeaux.inra.fr ([147.100.111.220]:38771 "EHLO
	mail-1.bordeaux.inra.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753701AbbFPG1y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Jun 2015 02:27:54 -0400
Received: from [147.100.98.136] ([147.100.98.136])
	(authenticated bits=0)
	by mail-1.bordeaux.inra.fr (/8.14.4) with ESMTP id t5G6Rp6s007342
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Jun 2015 08:27:51 +0200 (CEST)
Message-ID: <557FC1E7.6040108@bordeaux.inra.fr>
Date: Tue, 16 Jun 2015 08:27:51 +0200
From: Tovo Rabemanantsoa <tovo.rabemanantsoa@bordeaux.inra.fr>
MIME-Version: 1.0
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Bad performance with near-full FS
References: <557EC95C.8020902@bordeaux.inra.fr> <20150615132915.GM6761@twin.jikos.cz> <557EE4BF.2090908@bordeaux.inra.fr> <557EF12E.6000309@gmail.com>
In-Reply-To: <557EF12E.6000309@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/15/2015 05:37 PM, Austin S Hemmelgarn wrote:

> For almost any non-COW filesystem (ext4, XFS, JFS, etc.), 1% or 100MB
> (whichever is larger) is generally a good buffer.  On BTRFS, I would say
> at least 5% or 1.5G (again, whichever is larger; and if performance is a
> concern, go for at least 10-20%), as BTRFS is known to have some rather
> poor behavior when running very close to full.
> 
> 
I got it.
Thanks all !

T.
