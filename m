Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:41279 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579Ab3AWCfi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jan 2013 21:35:38 -0500
Message-ID: <50FF4C66.5080003@csamuel.org>
Date: Wed, 23 Jan 2013 13:35:18 +1100
From: Chris Samuel <chris@csamuel.org>
MIME-Version: 1.0
To: Brendan Hide <brendan@swiftspirit.co.za>
CC: Gene Czarcinski <gene@czarc.net>, linux-btrfs@vger.kernel.org,
        Josef Bacik <jbacik@fusionio.com>
Subject: Re: [PATCH 6/6] Btrfs-progs: detect if the disk we are formatting
 is a ssd
References: <1358618781-26629-1-git-send-email-gene@czarc.net> <1358618781-26629-7-git-send-email-gene@czarc.net> <50FB0CA1.4070204@swiftspirit.co.za>
In-Reply-To: <50FB0CA1.4070204@swiftspirit.co.za>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 20/01/13 08:14, Brendan Hide wrote:

> Can't help but suggest that a "NO_DEDUP" command could be added to the
> SATA Transport Protocol/SCSI Command set. Not sure where to submit that
> idea ... :-/

Serial ATA International Organization (SATA-IO) maintain the specs for
SATA. Looks like membership is limited to companies and costs US$1,700 a
year.

http://sata-io.org/

SCSI is from the T10 committee:

http://www.t10.org/

The intro page indicates it's a fairly open group:

# T10 operates under INCITS and is responsible for SCSI Storage
# Interfaces. Its principal work is the Small Computer System
# Interface (SCSI), including the family of SCSI-3 projects.
# Anyone "directly and materially affected" is welcome to
# participate on T10 (essentially, this amounts to anyone
# interested in T10's work).

cheers,
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
