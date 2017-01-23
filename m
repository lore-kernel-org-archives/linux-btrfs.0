Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:60587 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751082AbdAWUdo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Jan 2017 15:33:44 -0500
Subject: Re: Hard crash on 4.9.5
To: Matt McKinnon <matt@techsquare.com>, linux-btrfs@vger.kernel.org
References: <83c1a49a-b2ea-c7b6-151d-cbd15b6c9c93@techsquare.com>
 <b1779afa-a3c0-b86a-f3bb-f2b469bd6c9b@mendix.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <e5d98db4-7c3d-b4c5-d6c0-ecac828de1d9@mendix.com>
Date: Mon, 23 Jan 2017 21:33:42 +0100
MIME-Version: 1.0
In-Reply-To: <b1779afa-a3c0-b86a-f3bb-f2b469bd6c9b@mendix.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/23/2017 09:27 PM, Hans van Kranenburg wrote:
> [... press send without rereading ...]
> 
> Anyway, it seems to point to something that's going wrong with changes
> that are *not* on disk *yet*, and the crash is preventing ...

... whatever incorrect data this situation might result in from reaching
disk, at least.

-- 
Hans van Kranenburg
