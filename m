Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:43147 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbaEERkY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 May 2014 13:40:24 -0400
Received: from ruthven.local ([10.73.18.16] helo=ruthven.carfax.org.uk)
	by frost.carfax.org.uk with esmtp (Exim 4.80)
	(envelope-from <hugo@carfax.org.uk>)
	id 1WhMMp-0007ai-UV
	for linux-btrfs@vger.kernel.org; Mon, 05 May 2014 17:07:52 +0000
Received: from [10.0.0.10] (helo=ruthven.carfax.org.uk)
	by ruthven.carfax.org.uk with esmtp (Exim 4.82)
	(envelope-from <hugo@carfax.org.uk>)
	id 1WhMMp-0002Pg-CX
	for linux-btrfs@vger.kernel.org; Mon, 05 May 2014 18:07:51 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Subject: [[PATCH] 0/3] btrfs-check: Fix bitflipped keys from bad RAM
Date: Mon,  5 May 2014 18:07:48 +0100
Message-Id: <1399309671-9240-1-git-send-email-hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If you have RAM with stuck or unreliable bits in it, and a metadata block is
stored in it, you can end up with keys with errors in. These usually show up
as "bad key order". In many cases, these out-of-order keys can be identified
and fixed with a simple heuristic. This patch series implements that
heuristic, and fixes a long-standing issue with the existing code to fix out-
of-order keys.

Hugo Mills (3):
  btrfs check: Fix wrong level access
  btrfs check: Pre-sort keys in a block while searching
  btrfs check: Attempt to fix misordered keys with bitflips in them

 cmds-check.c | 114 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 ctree.c      |  86 ++++++++++++++++++++++++++++++++++++--------
 ctree.h      |   2 ++
 3 files changed, 180 insertions(+), 22 deletions(-)

-- 
1.9.2

