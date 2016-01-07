Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-out1.informatik.tu-muenchen.de ([131.159.0.8]:45394 "EHLO
	mail-out1.informatik.tu-muenchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752929AbcAGRe1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Jan 2016 12:34:27 -0500
Subject: Re: Purposely using btrfs RAID1 in degraded mode ?
To: Alphazo <alphazo@gmail.com>, Psalle <psalleetsile@gmail.com>
References: <CAHJqNbyXUfzscHteqrQtxJdYKToDNv7_Hw9tVpPuNJYwe=NHxw@mail.gmail.com>
 <568BF078.8060303@gmail.com>
 <CAHJqNbypeuLyYHEzH+4nPbmS=nTkeP6hgG+H+vuiQJTjP=t0vA@mail.gmail.com>
 <568E60CF.70004@gmail.com>
 <CAHJqNbxnB9o-UwXyLf+PvttnNOcf88FwhEep1FSkye1Etp0CTA@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Sree Harsha Totakura <sreeharsha@totakura.in>
Message-ID: <568EA19F.4040804@totakura.in>
Date: Thu, 7 Jan 2016 18:34:23 +0100
MIME-Version: 1.0
In-Reply-To: <CAHJqNbxnB9o-UwXyLf+PvttnNOcf88FwhEep1FSkye1Etp0CTA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you Alphazo; I have been looking for something similar for a
while, but didn't know where/what to look at.
Your pointers solve my problem.

Regards,
Sree
On 01/07/2016 02:09 PM, Alphazo wrote:
> I'm a former bup user but I switched to borgbackup
> https://borgbackup.readthedocs.org/en/stable/ which is a more active
> fork of Attic and that solves two issues I had with bup: increasing
> time required to perform the incremental backup on large dataset with
> only few modifications and more importantly the impossibility to prune
> older backups. Also borgbackup natively supports encryption (AES256)
> and authentication (HMAC-SHA256).
> 
> For offline long term backups I also used to work with hashdeep to
> perform and store a hash of all the files and recently started playing
> with FIM https://evrignaud.github.io/fim/ which is similar but with a
> git backend for storing history. Don't get fooled by fim being a java
> application. It easily outperformed hashdeep on large datasets.
> 
> Alphazo

