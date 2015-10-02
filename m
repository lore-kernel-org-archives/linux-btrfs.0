Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.uni-paderborn.de ([131.234.142.9]:52345 "EHLO
	mail.uni-paderborn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbbJBHXj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Oct 2015 03:23:39 -0400
To: linux-btrfs@vger.kernel.org
From: - <robert86@mail.uni-paderborn.de>
Subject: Deduplication and redundancy questions
Message-ID: <560E2CE9.6020500@mail.uni-paderborn.de>
Date: Fri, 2 Oct 2015 09:06:17 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hey everybody.

1. Deduplication
"When given a list of files it will hash their contents on a block by 
block basis" - are those static blocks or is the length of a block 
defined by its content? (that would be more resilient regarding inserts 
of data and the shift of the following data caused by it)

Do I understand correctly, that I better use bedup to deduplicate on a 
file-level before using duperomve to deduplicate on a block-level?

2. Redundany
"Background scrub process for finding and fixing errors on files with 
redundant copies "
So fixing is only available with full redundancy?! No parity-based 
methods or other ECC-based approaches?!

thanks for answers
