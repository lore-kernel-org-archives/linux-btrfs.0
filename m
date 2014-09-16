Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f44.google.com ([209.85.216.44]:47864 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbaIPXUW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Sep 2014 19:20:22 -0400
Received: by mail-qa0-f44.google.com with SMTP id w8so788793qac.17
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Sep 2014 16:20:22 -0700 (PDT)
MIME-Version: 1.0
From: Ames Cornish <ames@cornishes.net>
Date: Tue, 16 Sep 2014 16:20:02 -0700
Message-ID: <CAP6pX26V4684bq=d3eU7G0meLJPo9F3hYnoEwxOqTukp3DAcaw@mail.gmail.com>
Subject: Buttersink 0.4.1 - like rsync for btrfs snapshots
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've just released version 0.4.1 of buttersink.  As of this version, I
consider it "beta" and out of the experimental phase.

Buttersink will synchronize a set of read-only snapshots in a btrfs
filesystem to an Amazon S3 bucket, and vice-versa.  It intelligently
picks parent snapshots to "diff" from and send, so that a minimal
amount of data needs to be sent over the wire and stored in the
backend.

I've put a fair amount of effort into making buttersink efficient and
reliable enough for backups. Currently implemented features include:

- Transfers between a local btrfs filesystem and an Amazon S3 bucket
- Automatically synchronizes a set of snapshots, or a single snapshot,
transferring only needed differences
- Intelligent selection of full and incremental transfers to minimize
costs of transfer and storage, and to minimize risks from corruption
of a difference
- Smart heuristics based on S3 file sizes, btrfs quota information,
and btrfs-tools internal snapshot parent identification ("ruuid")
- Resumable, checksummed multi-part uploads to S3 as a back-end
- Robust handling of btrfs send and receive errors
- Configurable verbosity and logging
- Conveniently lists snapshots and sizes in either btrfs or S3
- Detects and (optionally) deletes failed partial transfers

If there's interest, I'll extend it to sync to a remote btrfs
filesystem as well.

The utility is on PyPi as "buttersink", and the GitHub page is here:
  https://github.com/AmesCornish/buttersink.

Thanks in advance for any feedback!

- Ames
