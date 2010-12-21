From: Chris Samuel <chris@csamuel.org>
Subject: Re: [TRIVIAL][PATCH] Improve error handling in the btrfs command
Date: Tue, 21 Dec 2010 11:29:48 +1100
Message-ID: <4D0FF4FC.9060502@csamuel.org>
References: <201012202106.26603.kreijack@libero.it> <4D0FDBE7.3070905@csamuel.org> <201012202353.29222.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: kreijack@libero.it
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201012202353.29222.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

On 21/12/10 09:53, Goffredo Baroncelli wrote:

> Some time I needed to add other info, so perror(3) may not be sufficient..

Ah, of course, and you cannot rely on safely snprintf()'ing
something into the string would get passed to perror() because
that could easily change errno if something went wrong internally.

All the best,
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
