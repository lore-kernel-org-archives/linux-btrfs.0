Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx-relay36-dus.antispameurope.com ([94.100.134.236]:50658 "EHLO
	mx-relay36-dus.antispameurope.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751352AbcGEJgF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Jul 2016 05:36:05 -0400
Date: Tue, 5 Jul 2016 11:28:49 +0200
From: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>
To: <praiskup@redhat.com>, <adilger@dilger.ca>
CC: <linux-btrfs@vger.kernel.org>, <bug-tar@gnu.org>
Subject: Re: [Bug-tar] stat() on btrfs reports the st_blocks with delay (data
 loss in archivers)
Message-ID: <577b7dd1.tgcc3Oz1nmHZ676h%Joerg.Schilling@fokus.fraunhofer.de>
References: <2628320.PvJcFm1FZr@unused-4-107.brq.redhat.com>
 <A865BDE1-B7F5-4D3B-9C0C-96E5A55B5410@dilger.ca>
In-Reply-To: <A865BDE1-B7F5-4D3B-9C0C-96E5A55B5410@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Andreas Dilger <adilger@dilger.ca> wrote:

> I think in addition to fixing btrfs (because it needs to work with existing
> tar/rsync/etc. tools) it makes sense to *also* fix the heuristics of tar
> to handle this situation more robustly.  One option is if st_blocks == 0 then
> tar should also check if st_mtime is less than 60s in the past, and if yes
> then it should call fsync() on the file to flush any unwritten data to disk,
> or assume the file is not sparse and read the whole file, so that it doesn't
> incorrectly assume that the file is sparse and skip archiving the file data.

A broken filesystem is a broken filesystem.

If you try to change gtar to work around a specific problem, it may fail in 
other situations.

Jörg

-- 
 EMail:joerg@schily.net                    (home) Jörg Schilling D-13353 Berlin
       joerg.schilling@fokus.fraunhofer.de (work) Blog: http://schily.blogspot.com/
 URL:  http://cdrecord.org/private/ http://sourceforge.net/projects/schilytools/files/'
