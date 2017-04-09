Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:44074 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751061AbdDIAjL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Apr 2017 20:39:11 -0400
Subject: Re: About free space fragmentation, metadata write amplification and
 (no)ssd
To: Peter Grandi <pg@btrfs.list.sabi.co.UK>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
References: <5e11b988-05ea-c468-21ef-589c71058436@mendix.com>
 <22761.23640.216570.125948@tree.ty.sabi.co.uk>
 <e3e2c13c-8f5d-2848-a3f6-759259d84d9d@mendix.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <1ad329a5-5071-fba6-3281-fd81c53497d8@mendix.com>
Date: Sun, 9 Apr 2017 02:39:09 +0200
MIME-Version: 1.0
In-Reply-To: <e3e2c13c-8f5d-2848-a3f6-759259d84d9d@mendix.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/09/2017 02:21 AM, Hans van Kranenburg wrote:
> [...]
> Notice that everyone who has rotational 0 in /sys is experiencing this
> behaviour right now, when removing snapshots... [...]

Eh, 1

-- 
Hans van Kranenburg
