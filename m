From: Chris Samuel <chris@csamuel.org>
Subject: Re: [PATCH] btrfs: checking NULL or not in some functions
Date: Wed, 02 Feb 2011 16:07:26 +1100
Message-ID: <4D48E68E.7000502@csamuel.org>
References: <201102010917.AA00006@T-ITOH1.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201102010917.AA00006@T-ITOH1.jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 01/02/11 20:17, Tsutomu Itoh wrote:

> Because NULL is returned when the memory allocation fails,
> it is checked whether it is NULL. 

Were the callers modified to cope with these functions
returning -ENOMEM ?

cheers,
Chris (way behind with email)
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
