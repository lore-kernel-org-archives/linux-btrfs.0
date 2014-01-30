Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:44139 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbaA3A1q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jan 2014 19:27:46 -0500
Received: by mail-ea0-f172.google.com with SMTP id l9so205929eaj.3
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Jan 2014 16:27:45 -0800 (PST)
Received: from localhost (host-115-115.kawo1.rwth-aachen.de. [134.130.115.115])
        by mx.google.com with ESMTPSA id v1sm15327664eef.9.2014.01.29.16.27.43
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Wed, 29 Jan 2014 16:27:44 -0800 (PST)
From: Gerhard Heift <gerhard@heift.name>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFCv3] new ioctl TREE_SEARCH_V2
Date: Thu, 30 Jan 2014 01:27:25 +0100
Message-Id: <1391041651-15689-1-git-send-email-Gerhard@Heift.Name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch series adds a new ioctl TREE_SEARCH_V2 with which we could store the
results in a varying buffer. With that even items larger than 3992 bytes or a
large amount of items can be returned. This is the case e.g. for some
EXTENT_CSUM items, which could have a size up to 16k.

I had a few questions:

  Which value should I assign to TREE_SEARCH_V2?
  * Chosen value is ok [1].

  Should we limit the buffer size?
  * David suggested [1] a minimum of 64k, I've chosen a cap of 16M.

  What about documentation?
  * I documented the new struct in the header file.

Gerhard

[1] http://article.gmane.org/gmane.comp.file-systems.btrfs/32060

Changelog

RFCv3
  * introduced read_extent_buffer_to_user
  * direct copy to user without intermediate buffer
  * use local variables for args
  * fixed wrong error code
  * removed unused var check
  * fixed minor style issues
  * return needed buffer to userspace on EOVERFLOW

RFCv2
  * fixed a build bug caused by using a wrong patch
  * added a patch to expand a buffer lifetime
