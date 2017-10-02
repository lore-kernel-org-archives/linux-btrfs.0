Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16-i6.italiaonline.it ([213.209.14.16]:54019 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751214AbdJBVuP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Oct 2017 17:50:15 -0400
Reply-To: kreijack@inwind.it
Subject: Re: Mount error on 32 bits, ok on 64 bits
To: Jean-Denis Girard <jd.girard@sysnux.pf>, linux-btrfs@vger.kernel.org
References: <oqk7mb$gud$1@blaine.gmane.org> <oqklhq$mas$1@blaine.gmane.org>
 <oqpnff$ob1$1@blaine.gmane.org> <oqtuql$k3j$1@blaine.gmane.org>
 <15e1f555-9557-0854-e910-300d882f321d@libero.it>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <635ac38a-189c-38b6-a4ae-1628135ae3a7@inwind.it>
Date: Mon, 2 Oct 2017 23:50:13 +0200
MIME-Version: 1.0
In-Reply-To: <15e1f555-9557-0854-e910-300d882f321d@libero.it>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/02/2017 11:46 PM, Goffredo Baroncelli wrote:
> which on 32bit is 32 bit if CONFIG_LBDAF is _not_ defined (CONFIG_LBDAF == Support for large (2TB+) block devices and files)

Only now I noticed that in the first email you attached the config; in fact in your config CONFIG_LBDAF is not set.

BR
G.Baroncelli
-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
