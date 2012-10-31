Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49724 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab2JaXZT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Oct 2012 19:25:19 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so1017449eek.19
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Oct 2012 16:25:18 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 31 Oct 2012 15:25:18 -0800
Message-ID: <CANmUDYsPqS9ZUVWhzxQv4G6fkQaRbGa2M3TTECp+tujJtyN4EA@mail.gmail.com>
Subject: find-new possibility of showing modified and deleted files/directories
From: Shane Spencer <shane@bogomip.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently find-new only shows certain operations and probably for a great
reason.

I'm trying to use find-new to preseed a file list to rsync so that I don't
have to traverse incredibly large directory trees.

Unfortunately find-new doesn't show deletion and a few other modifications.

I'm very tempted to use snapshots and decode a transfer log to get at this
information since that seems the most supportable way of doing this at the
moment.

Is it possible to enable all file modification types into the results of
find-new including unlink?

- Shane
