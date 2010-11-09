From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: Btrfs-progs: add support for mixed data+metadata block groups V4
Date: Tue, 9 Nov 2010 19:45:50 +0100
Message-ID: <201011091945.50379.kreijack@libero.it>
References: <1289324502-7387-1-git-send-email-mitch.harder@sabayonlinux.org>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1289324502-7387-1-git-send-email-mitch.harder@sabayonlinux.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday, 09 November, 2010, Mitch Harder wrote:
> So alot of crazy people (I'm looking at you Meego) want to use btrfs
> on phones and such with small devices.  Unfortunately the way we split
> out metadata/data chunks it makes space usage inefficient for volumes
> that are smaller than 1gigabyte.  So add a -M option for mixing
> metadata+data, and default to this mixed mode if the filesystem is less
> than or equal to 1 gigabyte.  I've tested this with xfstests on a 100mb
> filesystem and everything is a-ok.
[...]
> @@ -274,6 +295,7 @@ static void print_usage(void)
>  	fprintf(stderr, "\t -l --leafsize size of btree leaves\n");
>  	fprintf(stderr, "\t -L --label set a label\n");
>  	fprintf(stderr, "\t -m --metadata metadata profile, values like data 
profile\n");
> +	fprintf(stderr, "\t -M --mixed mix metadata and data together\n");
>  	fprintf(stderr, "\t -n --nodesize size of btree nodes\n");
>  	fprintf(stderr, "\t -s --sectorsize min block allocation\n");
>  	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);

Please, update the man page (mkfs.btrfs) page too with the new switch.

Regards
G.Baroncelli
-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
