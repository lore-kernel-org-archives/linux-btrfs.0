From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: Read errors while benchmarking
Date: Thu, 18 Jun 2009 11:00:56 +0200
Message-ID: <4A3A0248.80905@wpkg.org>
References: <q6apg6-5d2.ln1@phenom2.trippelsdorf.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <q6apg6-5d2.ln1@phenom2.trippelsdorf.de>
List-ID: <linux-btrfs.vger.kernel.org>

Markus Trippelsdorf wrote:
> I'm running the latest git kernel and git btrfs-progs. 
> When I try to run some benchmarks on my btrfs partition I always get
> read errors:

(...)


> FATAL: Failed to read file! file: 3 pos: 196608 errno = 22 ()
> FATAL: Failed to read file! file: 13 pos: 524288 errno = 22 ()

Anything interesting in dmesg?


-- 
Tomasz Chmielewski
http://wpkg.org
