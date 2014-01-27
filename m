Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:34567 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687AbaA0N24 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jan 2014 08:28:56 -0500
Received: by mail-ee0-f45.google.com with SMTP id b15so2259896eek.32
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jan 2014 05:28:55 -0800 (PST)
Received: from localhost (host-115-115.kawo1.rwth-aachen.de. [134.130.115.115])
        by mx.google.com with ESMTPSA id 46sm42512336ees.4.2014.01.27.05.28.53
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Mon, 27 Jan 2014 05:28:54 -0800 (PST)
From: Gerhard Heift <gerhard@heift.name>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFCv2] new ioctl TREE_SEARCH_V2
Date: Mon, 27 Jan 2014 14:28:26 +0100
Message-Id: <1390829312-814-1-git-send-email-Gerhard@Heift.Name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch series adds a new ioctl TREE_SEARCH_V2 with which we could store the
results in a varying buffer. Now even items larger than 3992 bytes or a large
amount of items can be returned.

I have a few questions:
  Which value should I assign to TREE_SEARCH_V2?
  Should we limit the buffer size?
  What about documentation?

Changelog

RFCv2
  * fixed a build bug caused by using a wrong patch
  * added a patch to expand buffer lifetime

Gerhard

