Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www.storix.com ([64.87.16.70]:33881 "EHLO storix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757610Ab3DXUHj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Apr 2013 16:07:39 -0400
Received: from [192.168.1.126] (office [68.224.172.120])
	by storix.com (Postfix) with ESMTPA id 9FC61E09
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Apr 2013 12:59:53 -0700 (PDT)
Message-ID: <517839C2.7060905@storix.com>
Date: Wed, 24 Apr 2013 13:00:02 -0700
From: Rich Turner <rturner@storix.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: query btrfs creation options
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

i am looking for a way to query btrfs filesystems for all options used to create the filesystem 
(i.e. data, leafsize, label, metadata, nodesize, sectorsize) in an effort to be able to record this 
information and be able to recreate the filesystem with the same attributes if necessary.

i see there is a feature request for creating an api/library that may provide this functionality, 
but i am unable to find any suitable userspace command that provides the information.
