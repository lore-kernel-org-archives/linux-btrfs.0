From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: btrfs subvolume snapshot syntax too "smart"
Date: Mon, 04 Apr 2011 21:47:10 +0200
Message-ID: <4D9A203E.9090807@libero.it>
References: <BANLkTikvyUH2Dhm2p=N-GSzy7r4_nj=bNg@mail.gmail.com>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "krzf83@gmail.com" <krzf83@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTikvyUH2Dhm2p=N-GSzy7r4_nj=bNg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 04/04/2011 09:09 PM, krzf83@gmail.com wrote:
> I understand btrfs intent but same command run twice should not give
> diffrent results. This really makes snapshot automation hard
> 
> 
> root@sv12 [/ssd]# btrfs subvolume snapshot /ssd/sub1 /ssd/5
> Create a snapshot of '/ssd/sub1' in '/ssd/5'
> root@sv12 [/ssd]# btrfs subvolume snapshot /ssd/sub1 /ssd/5
> Create a snapshot of '/ssd/sub1' in '/ssd/5/sub1'
> root@sv12 [/ssd]# btrfs subvolume snapshot /ssd/sub1 /ssd/5
> Create a snapshot of '/ssd/sub1' in '/ssd/5/sub1'
> ERROR: cannot snapshot '/ssd/sub1'

The same is true for cp:

# cp -rf /ssd/sub1 /ssd/5	-> copy "sub1" as "5"
# cp -rf /ssd/sub1 /ssd/5	-> copy "sub1" in "5"

However you are right. It could be fixed easily adding a switch like
"--script", which force to handle the last part of the destination as
the name of the subvolume, raising an error if it already exists.

"subvolume snapshot" is the only command which suffers of this kind of
problem ?

Regards
G.Baroncelli

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> .
> 

