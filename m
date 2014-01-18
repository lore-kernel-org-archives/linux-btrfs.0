Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:59640 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbaARAQP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jan 2014 19:16:15 -0500
Received: by mail-ee0-f50.google.com with SMTP id d17so2389662eek.23
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Jan 2014 16:16:14 -0800 (PST)
Received: from localhost (host-115-115.kawo1.rwth-aachen.de. [134.130.115.115])
        by mx.google.com with ESMTPSA id z49sm18010304eeo.10.2014.01.17.16.16.13
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Fri, 17 Jan 2014 16:16:13 -0800 (PST)
From: Gerhard Heift <gerhard@heift.name>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFC] new ioctl TREE_SEARCH_V2
Date: Sat, 18 Jan 2014 01:15:48 +0100
Message-Id: <1390004153-4228-1-git-send-email-Gerhard@Heift.Name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch series adds a new ioctl TREE_SEARCH_V2 with which we could store the
results in a varying buffer. Now even items larger than 3992 bytes or a large
amount of items can be returned.

I have a few questions:
  Which value should I assign to TREE_SEARCH_V2?
  Should we limit the buffer size?
  What about documentation?

Gerhard

