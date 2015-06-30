Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:35301 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbbF3JAU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Jun 2015 05:00:20 -0400
Received: by obbop1 with SMTP id op1so2237954obb.2
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2015 02:00:20 -0700 (PDT)
MIME-Version: 1.0
From: Amr El-Sharnoby <amr.elsharnoby@horizontechs.com>
Date: Tue, 30 Jun 2015 11:59:50 +0300
Message-ID: <CAGMys1p9=p-22mfSMCtMXgrmA=1mOs0mzRBTDmt_67q8D4OJEw@mail.gmail.com>
Subject: btrfs-progs 4.1 failed to compile on CentOS 6.x
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
Compilation of btrfs-progs 4.1 failed on CentOS 6.6 with latest
updated packages with the folllowing error,
In file included from cmds-inspect.c:28:
send-utils.h:97: error: wrong number of arguments specified for
‘deprecated’ attribute
send-utils.h:99: error: wrong number of arguments specified for
‘deprecated’ attribute
make: *** [cmds-inspect.o] Error 1

Previous version compile successfully.
