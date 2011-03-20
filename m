From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH RFC] btrfs: Simplify locking
Date: Sun, 20 Mar 2011 21:17:10 +0100
Message-ID: <20110320201710.GC12003@htj.dyndns.org>
References: <20110320174433.GA12003@htj.dyndns.org>
 <20110320195652.GB12003@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110320195652.GB12003@htj.dyndns.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 20, 2011 at 08:56:52PM +0100, Tejun Heo wrote:
> So, here's the patch to implement and use mutex_try_spin(), which
> applies the same owner spin logic to try locking.  The result looks
> pretty good.
> 
> I re-ran all three.  DFL is the current custom locking.  SIMPLE is
> with only the previous patch applied.  SPIN is both the previous and
> this patches applied.
> 
>        USER   SYSTEM   SIRQ    CXTSW  THROUGHPUT
> DFL    14484  129368    390  1669102     171.955
> SIMPLE 14483  128902    318  1187031     171.512
> SPIN   14311  129222    347  1198166     174.904
> 
> DFL/SIMPLE results are more or less consistent with the previous run.
> SPIN seems to consume a bit more cpu than SIMPLE but shows discernably
> better throughput.  I'm running SPIN again just in case but the result
> seems pretty consistent.

Here's another run.

  SPIN   14377  129092    335  1189817     172.724
  
It's not as high as the last run, but given other runs I've been
seeing, I think meaningful (ie. not measurement error) throughput
advantage exists.  That said, the difference definitely seems minor.

Thanks.

-- 
tejun
