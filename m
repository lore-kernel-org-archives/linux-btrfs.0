Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:56979 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636AbaA3PYL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jan 2014 10:24:11 -0500
Received: by mail-ea0-f179.google.com with SMTP id q10so1428634ead.10
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Jan 2014 07:24:10 -0800 (PST)
Received: from localhost (host-115-115.kawo1.rwth-aachen.de. [134.130.115.115])
        by mx.google.com with ESMTPSA id w4sm23869639eef.20.2014.01.30.07.24.08
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Thu, 30 Jan 2014 07:24:09 -0800 (PST)
From: Gerhard Heift <gerhard@heift.name>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFCv4] new ioctl TREE_SEARCH_V2
Date: Thu, 30 Jan 2014 16:23:56 +0100
Message-Id: <1391095443-20287-1-git-send-email-Gerhard@Heift.Name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch series first rewrites tree_search to copy found items directly to
userspace and then adds a new ioctl TREE_SEARCH_V2 with which we could store
them in a varying buffer. Now even items larger than 3992 bytes or a large
amount of items can be returned. This is the case for some EXTENT_CSUM items,
which could have a size up to 16k.

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

RFCv4
  * fixed copy to userspace (used wrong pointers)
  * eliminate a redundant check for nr_items

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
