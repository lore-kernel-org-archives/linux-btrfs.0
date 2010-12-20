From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: [TRIVIAL][PATCH] Improve error handling in the btrfs command
Date: Mon, 20 Dec 2010 23:53:29 +0100
Message-ID: <201012202353.29222.kreijack@libero.it>
References: <201012202106.26603.kreijack@libero.it> <4D0FDBE7.3070905@csamuel.org>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: linux-btrfs@vger.kernel.org
To: Chris Samuel <chris@csamuel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D0FDBE7.3070905@csamuel.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Monday, 20 December, 2010, you (Chris Samuel) wrote:
> On 21/12/10 07:06, Goffredo Baroncelli wrote:
> 
> > below is enclosed a trivial patch, which has the aim to
> > improve the error reporting of the "btrfs" command.
> 
> Any reason to not just use perror() ?

Some time I needed to add other info, so perror(3) may not be sufficient..
 

-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
