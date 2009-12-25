From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: btrfsctl exit with 1 when succeed
Date: Fri, 25 Dec 2009 10:25:56 +0100
Message-ID: <200912251025.57158.kreijack@libero.it>
References: <E88DD564E9DC5446A76B2B47C3BCCA150221B14DD3@pdsmsx503.ccr.corp.intel.com> <4B340502.10806@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: linux-btrfs@vger.kernel.org, zhipeng.gong@intel.com
To: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B340502.10806@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 25 December 2009, TARUISI Hiroaki wrote:
> I also want to know why this conversion is needed.
> This might be a typo, I think.
> 
> Could someone tell us why?
> Can we fix this conversion? Or shouldn't we fix it
> considering back-compatibility?
> 

It is even worse: the result code returned by btrfsctl is not coherent.
btrfsctl returns always 1 except:
- after a devices scan (in this case the result is _always_ 0)
- if the ioctl returns a value greater than 0 

In other all cases (error in the command line, the device btrfs-control 
doesn't exists, error in opening a file) the return code is 1.

That doesn't permit to differentiate an error from a good return. 

BR
Goffredo


> Regards,
> taruisi
> 
> (2009/11/11 15:16), Gong, Zhipeng wrote:
> > We'd like to use btrfsctl in a shell script, however, btrfsctl exit with 1 
even if the operation is successful, which is opposite to the usual shell 
command convention.
> > Why btrfsctl add this conversion in the end?
> >          if (ret)
> >                   exit(0);
> >          else
> >                   exit(1);
> > 
> > Thanks
> > Zhipeng
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
