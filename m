From: Premysl Hruby <dfenze@gmail.com>
Subject: Re: [PATCH] btrfs-progs: remove hard-coding of "gcc" and "make"
 from Makefile
Date: Mon, 21 Sep 2009 20:25:49 +0200
Message-ID: <20090921182549.GC10659@baldr.the>
References: <4AB7A76D.8050902@skyrush.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4AB7A76D.8050902@skyrush.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi

On (21/09/09 10:18), Joe Peterson wrote:
> Date:	Mon, 21 Sep 2009 10:18:53 -0600
> From: Joe Peterson <joe@skyrush.com>
> To: Btrfs Development List <linux-btrfs@vger.kernel.org>
> Subject: [PATCH] btrfs-progs: remove hard-coding of "gcc" and "make" from
>  Makefile
> User-Agent: Thunderbird 2.0.0.23 (X11/20090920)
> List-ID: <linux-btrfs.vger.kernel.org>

BTW:

> 
>  manpages:
> -	cd man; make
> +	cd man; $(MAKE)

	=> $(MAKE) -C man
>  
>  install-man:
> -	cd man; make install
> +	cd man; $(MAKE) install

	=> $(MAKE) -C man install

>  
>  clean :
>  	rm -f $(progs) cscope.out *.o .*.d btrfs-convert
> -	cd man; make clean
> +	cd man; $(MAKE) clean

	=> $(MAKE) clean
  


-- 
Premysl "Anydot" Hruby, http://www.redrum.cz/
-
I'm a signature virus. Please add me to your signature and help me spread!
