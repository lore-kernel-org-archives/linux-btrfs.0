From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: abysmal performance
Date: Sat, 30 Apr 2011 12:33:16 -0500
Message-ID: <BANLkTi=6YHDSmcg5DiHPiL1xWdT1nWobBg@mail.gmail.com>
References: <1304088305-sup-3784@localhost>
	<1304089239-sup-5110@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: John Wyzer <john.wyzer@gmx.de>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1304089239-sup-5110@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 29, 2011 at 10:01 AM, Chris Mason <chris.mason@oracle.com> =
wrote:
> Excerpts from John Wyzer's message of 2011-04-29 10:46:08 -0400:
>> Currently on
>> commit 7cf96da3ec7ca225acf4f284b0e904a1f5f98821
>> Author: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
>> Date: =A0 Mon Apr 25 19:43:53 2011 -0400
>> =A0 =A0 Btrfs: cleanup error handling in inode.c
>>
>> merged into 2.6.38.4
>>
>> I'm on a btrfs filesystem that has been used for some time. Let's sa=
y nine
>> months. Very recently I noticed performance getting worse and worse.
>> Most of the time it feels as if the system is just busy with iowait.
>> Write and read performance during random access is mostly around 2MB=
/s,
>> sometimes 1MB/s or slower. It's better for big files which can be re=
ad with about
>> 6-9MB/s. The disk is a reasonably recent SATA disk (WDC_WD3200BEVT) =
so 30MB/s
>> or 40MB/s linear reading should not be a problem.
>>
>> rootfs =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0291G =A0242G =A0 35G =A088% /
>>
>> I tried =A0btrfs filesystem defragment -v / but did not notice any i=
mprovement
>> after that.
>>
>> Is this a known phenomenon? :-)
>>
>
> Sounds like you're hitting fragmentation, which we can confirm with
> latencytop. =A0Please run latencytop while you're seeing poor perform=
ance
> and take a look at where you're spending most of your time.
>
> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Also, please note that 'btrfs filesystem defragment -v /' will
defragment the directory structure, but not the files.

See:
https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#Defragmenting_a_dir=
ectory_doesn.27t_work

To defragment your entire volume, you'll need a command like:

# for file in $(find <PATH/TO/BTRFS/VOL/> -type f); do btrfs
filesystem defragment ${file}; done

There's also a similar command in the FAQ referenced above.

If you just want to see your fragmentation you can use the 'filefrag'
program from e2fsprogs:

# for file in $(find <PATH/TO/BTRFS/VOL/> -type f); do filefrag
${file}; done | sort -n -k 2 | less
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
