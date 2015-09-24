Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.data-modul.de ([212.184.205.171]:19474 "EHLO
	mail2.data-modul.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752753AbbIXGSS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Sep 2015 02:18:18 -0400
From: Silvio Fricke <silvio.fricke@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Silvio Fricke <silvio.fricke@gmail.com>
Subject: [PATCH 0/2] progress indicator for btrfs-check
Date: Thu, 24 Sep 2015 08:13:03 +0200
Message-Id: <cover.1443074502.git.silvio.fricke@gmail.com>
In-Reply-To: <cover.1443012156.git.silvio.fricke@gmail.com>
References: <cover.1443012156.git.silvio.fricke@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello btrfs,

I have noticed that a long running process like "btrfs check" needs a progress
indicator. Please look into these patches. Besides that I have found a problem
with the task struct id value which is a pthread_t and not be set to -1.

Thanks for the review and eventual inclusion of these patches,
Silvio

(Please include my mailaddress silvio.fricke@gmail.com as CC in replies, i'm
not subscribed to linux-btrfs@vger.kernel.org)


Silvio Fricke (2):
  btrfs-progs: tasks info->id is a pthread_t and should not set to -1
  btrfs-progs: check: add progress indicator

 cmds-check.c | 93 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 task-utils.c |  4 +--
 2 files changed, 91 insertions(+), 6 deletions(-)

-- 
2.5.3

