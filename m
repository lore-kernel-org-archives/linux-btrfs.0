Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f171.google.com ([209.85.216.171]:33894 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbbCNReX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 Mar 2015 13:34:23 -0400
Received: by qcaz10 with SMTP id z10so13252119qca.1
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Mar 2015 10:34:22 -0700 (PDT)
Message-ID: <5504711C.1050500@gmail.com>
Date: Sat, 14 Mar 2015 13:34:20 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Robert White <rwhite@pobox.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Any Arguments for/against --bind mounts?
References: <5503AA56.4050407@pobox.com>
In-Reply-To: <5503AA56.4050407@pobox.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-03-13 23:26, Robert White wrote:
> Is there any practical reason to prefer bind mounts or separately
> mounting a subvolume?
> 
> e.g. assuming /locationA and /locationB are arbitrarily far apart in the
> file system tree, is there any reason to prefer one of the following
> over the other
> 
> mount -t btrfs -o subvolume=/thing /dev/sdN1 /locationA
> mount --bind /locationA /locationB
> 
> vs.
> 
> mount -t btrfs -o subvolume=/thing /dev/sdN1 /locationA
> mount -t btrfs -o subvolume=/thing /dev/sdN1 /locationB
> 
> Are both equally efficient and whatnot?
Internally, they're actually identical.

