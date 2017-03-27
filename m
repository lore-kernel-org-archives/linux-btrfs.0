Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([195.154.117.182]:53632 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752146AbdC0OtQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Mar 2017 10:49:16 -0400
Date: Mon, 27 Mar 2017 19:48:47 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Christian Theune <ct@flyingcircus.io>
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: Shrinking a device - performance?
Message-ID: <20170327194847.5c0c5545@natsu>
In-Reply-To: <3558CE2F-0B8F-437B-966C-11C1392B81F2@flyingcircus.io>
References: <1CCB3887-A88C-41C1-A8EA-514146828A42@flyingcircus.io>
        <20170327130730.GN11714@carfax.org.uk>
        <3558CE2F-0B8F-437B-966C-11C1392B81F2@flyingcircus.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 27 Mar 2017 15:20:37 +0200
Christian Theune <ct@flyingcircus.io> wrote:

> (Background info: we’re migrating large volumes from btrfs to xfs and can
> only do this step by step: copying some data, shrinking the btrfs volume,
> extending the xfs volume, rinse repeat. If someone should have any
> suggestions to speed this up and not having to think in terms of _months_
> then I’m all ears.)

I would only suggest that you reconsider XFS. You can't shrink XFS, therefore
you won't have the flexibility to migrate in the same way to anything better
that comes along in the future (ZFS perhaps? or even Bcachefs?). XFS does not
perform that much better over Ext4, and very importantly, Ext4 can be shrunk.

>From the looks of it Ext4 has also overcome its 16TB limitation:
http://askubuntu.com/questions/779754/how-do-i-resize-an-ext4-partition-beyond-the-16tb-limit

-- 
With respect,
Roman
