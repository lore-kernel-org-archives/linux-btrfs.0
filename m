Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandstone.cs.wisc.edu ([128.105.6.39]:56304 "EHLO
	sandstone.cs.wisc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbaKXBjl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Nov 2014 20:39:41 -0500
Received: from webmail.cs.wisc.edu (lilo.cs.wisc.edu [128.105.7.102])
	by sandstone.cs.wisc.edu (8.14.1/8.14.1) with ESMTP id sAO1Xf1C023696
	for <linux-btrfs@vger.kernel.org>; Sun, 23 Nov 2014 19:33:42 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Sun, 23 Nov 2014 19:33:41 -0600
From: ygovind <ygovind@cs.wisc.edu>
To: linux-btrfs@vger.kernel.org
Subject: Help with Btrfs TracePoints and FTrace
Message-ID: <cba79e6d37aee8454d5f9672fe2c6545@cs.wisc.edu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi - I have taken minor project on Btrfs file system as my independent 
study and trying to understand data/metadata allocation algorithm used 
in Btrfs file system. I would like to know how can I use Btrfs 
Tracepoints and Ftrace to debug. I was trying to find documents on web 
but wasn't able to find any document which can guide me through step by 
step process on using Btrfs Tracepoints or Ftrace on Btrfs.

All the study so far is happening on a laptop with virtual box Ubuntu. I 
have downloaded latest kernel and trying to understand the flow by 
putting printk statements and compiling that module. In this setup - if 
you can guide me through the process of setting up tracepoints or Ftrace 
- that will really help me. Also, if you have any other suggestions on 
understanding allocation algorithms for data/metadata - I am open to 
learn.

Best Regards,
Yash
