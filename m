From: Chris Samuel <chris@csamuel.org>
Subject: Re: [TRIVIAL][PATCH] Improve error handling in the btrfs command
Date: Tue, 21 Dec 2010 09:42:47 +1100
Message-ID: <4D0FDBE7.3070905@csamuel.org>
References: <201012202106.26603.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
	Ben Gamari <bgamari.foss@gmail.com>
To: kreijack@libero.it
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201012202106.26603.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

On 21/12/10 07:06, Goffredo Baroncelli wrote:

> below is enclosed a trivial patch, which has the aim to
> improve the error reporting of the "btrfs" command.

Any reason to not just use perror() ?

-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
