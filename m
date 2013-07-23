Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:58132 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756542Ab3GWL7g (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jul 2013 07:59:36 -0400
Received: by mail-pd0-f181.google.com with SMTP id 14so8073169pdj.12
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Jul 2013 04:59:36 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 23 Jul 2013 06:59:35 -0500
Message-ID: <CA+V+5QrNAo_RVEiONHRqkN5O89jgtoFDecuWnu41_ovJmLVhuA@mail.gmail.com>
Subject: Q: Why subvolumes?
From: Jerome Haltom <wasabi@cogito.cx>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

May I ask why the decision to implement snapshotting through
subvolumes? I've been very curious about why the design wasn't to
simply allow snapshotting of any directory or file.
