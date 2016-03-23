Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:36460 "EHLO
	mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbcCWCOw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Mar 2016 22:14:52 -0400
Received: by mail-io0-f176.google.com with SMTP id 124so10327732iov.3
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Mar 2016 19:14:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRfc+vG5kP8s=BNw44+HTQYKXTC7w5Lwsx98D1+3_kPMw@mail.gmail.com>
References: <CAJCQCtRfc+vG5kP8s=BNw44+HTQYKXTC7w5Lwsx98D1+3_kPMw@mail.gmail.com>
Date: Tue, 22 Mar 2016 20:14:51 -0600
Message-ID: <CAJCQCtQgST4=YA0eNgDrdAa8epQyockGRQbFuSgEJMjiQy8pAA@mail.gmail.com>
Subject: Re: reflink copy 'invalid argument'
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

OK OK, Mr. Short Term Memory here.

The target images/ directory has +C xattr. When removed the problem
doesn't happen. I've run into this before, and asked about it on the
list before. So yeah...


Chris Murphy
