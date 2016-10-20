Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-02v.sys.comcast.net ([96.114.154.161]:47389 "EHLO
        resqmta-po-02v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754571AbcJTLk6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Oct 2016 07:40:58 -0400
Date: Thu, 20 Oct 2016 06:40:55 -0500
From: Tim Walberg <twalberg@comcast.net>
To: linux-btrfs@vger.kernel.org
Cc: "Walberg, Tim" <tew@twin.jikos.cz>
Subject: regression in quota rescan, or intentional?
Message-ID: <20161020114055.GD9047@comcast.net>
Reply-To: Tim Walberg <twalberg@comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Just updated my kernel and btrfs-tools to 4.8.1 and now it seems
that "btrfs quota rescan -w <filesystem>" does not in fact wait
for the rescan to finish. Running it a second time immediately
after does, however.

Was this an intentional change, or is it a regression/bug?

-- 
twalberg@gmail.com, twalberg@comcast.net
