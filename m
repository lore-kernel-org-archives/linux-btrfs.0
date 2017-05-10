Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rin.romanrm.net ([91.121.86.59]:36130 "EHLO rin.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751527AbdEJHSn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 May 2017 03:18:43 -0400
Date: Wed, 10 May 2017 12:18:40 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: runtime btrfsck
Message-ID: <20170510121840.06aa01b2@natsu>
In-Reply-To: <5d86903f-96f8-b61c-16b0-15ba9ac48986@profihost.ag>
References: <9267c96a-72a7-0726-d058-4b2589d7e73e@profihost.ag>
        <f5c610b2-7400-2507-9db2-021b22c0b6d9@profihost.ag>
        <5d86903f-96f8-b61c-16b0-15ba9ac48986@profihost.ag>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 10 May 2017 09:02:46 +0200
Stefan Priebe - Profihost AG <s.priebe@profihost.ag> wrote:

> how to fix bad key ordering?

You should clarify does the FS in question mount (read-write? read-only?)
and what are the kernel messages if it does not.

-- 
With respect,
Roman
