Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:40496 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbaIYTjm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Sep 2014 15:39:42 -0400
Received: by mail-lb0-f178.google.com with SMTP id z12so10789555lbi.9
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Sep 2014 12:39:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOsFrTcVrWjSks0K-NzokHinBZVRxGGwmRzG_tdzxaU7AAC=xQ@mail.gmail.com>
References: <16424080.RP99VxSJe8@ubuntu>
	<pan$afb89$92478dcc$d289358e$905b34a@cox.net>
	<CAOsFrTcVrWjSks0K-NzokHinBZVRxGGwmRzG_tdzxaU7AAC=xQ@mail.gmail.com>
Date: Thu, 25 Sep 2014 21:39:41 +0200
Message-ID: <CAOsFrTfwOqGLjBxsZMsDUSy8pT=2zE-nnQYTiC9trmMkuk7_cQ@mail.gmail.com>
Subject: Re: btrfs send does not work from readonly device
From: G EO <1g2e3o4@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The snapshots underneath are set read only anyway in my case, since
the they landed there by btrfs receive or I am thinking wrong here?
Duncan, do you remember the bug number?


Thanks!
