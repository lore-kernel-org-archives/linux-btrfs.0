From: "Andrea Gelmini" <andrea.gelmini@gmail.com>
Subject: Re: different oops
Date: Fri, 3 Oct 2008 19:16:52 +0200
Message-ID: <9cdbb57f0810031016m5ba208a8xbaa0a9e963a7b887@mail.gmail.com>
References: <200810031814.06897.mbuerger@edu.uni-klu.ac.at>
	 <1223052035.13375.27.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "Chris Mason" <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1223052035.13375.27.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

2008/10/3 Chris Mason <chris.mason@oracle.com>:
> This is a long standing bug that so far we've only heard about on gentoo
> installs.  Could you please give the attached patch a try against your
> sources?

I've got same problem, with lastest ubuntu, and my own kernel (vanilla).
I can trigger disk copying ~2GB of data from my home to btrfs (65GB
test partition), everytime I try.

It seems easier to trigger when copying files of size > 300MB.

I can give you root access to my laptop if it helps.

Ciao,
Gelma
