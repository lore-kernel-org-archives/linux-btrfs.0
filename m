From: Chris Samuel <chris@csamuel.org>
Subject: Re: btrfs-convert fails
Date: Tue, 02 Nov 2010 11:43:11 +1100
Message-ID: <4CCF5E9F.1040001@csamuel.org>
References: <20101101104943.00007ff9@unknown>	<B$1ssrji1uB@helmut.hullen.de> <AANLkTi=qwtEwBTxsqEBzQ78QA852wh9RDG-HNmABpj22@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=qwtEwBTxsqEBzQ78QA852wh9RDG-HNmABpj22@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 01/11/10 23:20, cwillu wrote:

> Problems resulting from powerloss should be limited to faulty hardware
> (in which case you're screwed regardless of the filesystem) and lack
> of barrier support (which should show up in dmesg soon after the first
> write goes to disk).

Note that for until 2.6.31 the DM layer didn't support barrier
operations fully, according to this email:

http://www.spinics.net/lists/linux-ext4/msg15789.html

# Barrier infrastructure started to get added to the DM
# core in 2.6.30, see: http://git.kernel.org/linus/af7e466a1ace
#
# But barriers were not enabled for all DM targets (_except_
# dm-multipath) until 2.6.31.  So 2.6.31's dm-crypt does support
# barriers, see: http://git.kernel.org/linus/647c7db14ef9
#
# If the underlying device(s) support barriers DM should
# faithfully pass them on (again except for dm-multipath).
# Also, requests with barriers that result in -EOPNOTSUPP
# are retried without the barrier, see:
# http://git.kernel.org/linus/51aa32284958

cheers,
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
