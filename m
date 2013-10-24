Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from exprod5og109.obsmtp.com ([64.18.0.188]:35010 "EHLO
	exprod5og109.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755594Ab3JXPe2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Oct 2013 11:34:28 -0400
Received: from kipc2.localdomain (unknown [3.249.69.203])
	by mail-rly-prd-02.am.health.ge.com (Postfix) with ESMTP id 0B4374EAE0
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Oct 2013 15:29:21 +0000 (GMT)
Date: Thu, 24 Oct 2013 17:29:56 +0200
From: Karl Kiniger <karl.kiniger@med.ge.com>
To: linux-btrfs@vger.kernel.org
Subject: Why cannot I move a read-only snapshot around?
Message-ID: <20131024152955.GA6110@kipc2.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear list, (newbie alert)

After sucessfully sending and receiving a dozen of  related snapshots
I want to move them all to the readonly folder but I cannot:

ls -l
.....
drwxr-xr-x. 1 root root 682 Oct 24 16:01 @20131001
drwxr-xr-x. 1 root root 682 Oct 24 16:07 @20131004
drwxr-xr-x. 1 root root 682 Oct 24 16:10 @20131008
drwxr-xr-x. 1 root root 682 Oct 24 16:16 @20131010
drwxr-xr-x. 1 root root 682 Oct 24 16:23 @20131014
drwxr-xr-x. 1 root root 706 Oct 24 16:24 @20131018
drwxr-xr-x. 1 root root 706 Oct 24 16:31 @20131021
drwxr-xr-x. 1 root root 734 Oct 24 16:36 @20131023
drwxr-xr-x. 1 root root 734 Oct 24 16:41 @20131024
drwxr-xr-x. 1 root root 734 Oct 24 16:41 F19
drwxr-xr-x. 1 root root   0 Oct 24 17:21 readonly


mv \@20131024 readonly

mv: cannot move ‘@20131024’ to ‘readonly/@20131024’: Read-only file system

I know I can create other new ro  snapshots within the readonly directory
and then delete those above but in the future I want to send/receive based on
those snapshots (send -p .... -c .... -c ....) but I want to move them
to a more  convenient place.

How can I move them without re-sending all?

Karl

