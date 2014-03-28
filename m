Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f178.google.com ([209.85.220.178]:38440 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbaC1VOr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Mar 2014 17:14:47 -0400
Received: by mail-vc0-f178.google.com with SMTP id im17so6389526vcb.37
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Mar 2014 14:14:46 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 28 Mar 2014 17:14:46 -0400
Message-ID: <CAJtFHUQQdv-oz=W-ufoDs5+3ZP=2umzhuyd9uJX84jWtKFYDYQ@mail.gmail.com>
Subject: balance failure on large files
From: E V <eliventer@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

balance start -dprofiles=raid0,convert=single,vrange=0..580000000000000
fails given lots of space. Looking at the paths of the failed block groups via
btrfs inspect-internal logical-resolve, I see they are 7 largish
files, from 4G-133GB in size. So looks like the profile conversion
code hit's a snag in this case. I'm in the process of mv the files
away, and will try it again after to see if it works.
