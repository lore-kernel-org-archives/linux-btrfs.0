From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: Re: write(2) taking 4s
Date: Mon, 18 Jul 2011 11:39:12 +0100
Message-ID: <chaz20110718103912.GA4014@seebyte.com>
References: <20110708124429.GB4284@yahoo.fr> <1310137241-sup-8158@shiny> <20110709170959.GC4294@yahoo.fr> <CAE5mzvhZwrtEZ8FUfcYzoMsRwuPjNDn=iCZ6_-CKaifEPZWAKA@mail.gmail.com> <20110709203649.GE4294@yahoo.fr> <1310301809-sup-9903@shiny> <20110710183728.GB4277@yahoo.fr> <20110711090121.GA2537@yahoo.fr> <20110716121210.GA5638@yahoo.fr> <20110717091737.GA4301@yahoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110717091737.GA4301@yahoo.fr>
List-ID: <linux-btrfs.vger.kernel.org>

2011-07-17 10:17:37 +0100, Stephane Chazelas:
> 2011-07-16 13:12:10 +0100, Stephane Chazelas:
> > Still on my btrfs-based backup system. I still see one BUG()
> > reached in btrfs-fixup per boot time, no memory exhaustion
> > anymore. There is now however something new: write performance
> > is down to a few bytes per second.
> [...]
> 
> The condition that was causing that seems to have cleared by
> itself this morning before 4am.
> 
> flush-btrfs-1 and sync are still in D state.
> 
> Can't really tell what cleared it. Could be when the first of
> the rsyncs ended as all the other ones (and ntfsclones from nbd
> devices) ended soon after
[...]

New nightly backup, and it's happening again. Started about 40
minutes after the start of the backup.

----system---- -net/total- ---procs--- --dsk/sda-----dsk/sdb-----dsk/sdc--
     time     | recv  send|run blk new| read  writ: read  writ: read  writ
17-07 20:19:18|   0     0 |0.0 0.0 0.0| 142k   31k: 119k   36k: 120k   33k
17-07 20:19:48|8087k  224k|1.2 5.3 0.1|2976k   98k: 793k  400k:2856k  375k
17-07 20:20:18|5174k  134k|0.8 4.6 0.9| 880k  179k: 830k  916k:1801k  825k
17-07 20:20:48|6634k  148k|1.3 4.9 0.2| 609k  101k:1259k   96k:2628k   98k
17-07 20:21:18|6725k  165k|0.7 5.8 0.0| 237k  442k: 975k  723k:1870k  644k
17-07 20:21:48|7100k  153k|0.7 5.4   0| 305k   83k:1124k  314k:2155k  274k
17-07 20:22:18|4440k  178k|0.5 5.3 0.0| 296k 1775B:2094k  240k:1663k  239k
17-07 20:22:48|8181k  220k|0.9 5.8   0| 360k  410B:1579k  196k:2065k  196k
17-07 20:23:18|8144k  228k|1.3 5.6   0| 348k   54k:1781k  216k:2213k  164k
17-07 20:23:48|5506k  185k|0.8 5.2 0.1| 307k    0 :2040k    0 :2166k    0
17-07 20:24:18|6260k  206k|1.0 5.4 0.1| 474k   78k:2034k  285k:2218k  207k
17-07 20:24:48|8420k  314k|1.5 5.4   0| 313k  363k:2367k  391k:2182k  124k
17-07 20:25:18|8367k  247k|0.9 5.1 0.2| 475k   77k:1797k   75k:2220k  410B
17-07 20:25:48|7511k  179k|1.0 4.7   0| 406k 7646B:1596k  145k:2397k  147k
17-07 20:26:18|7930k  162k|0.7 5.1   0| 991k  410B:1468k   26k:2186k   26k
17-07 20:26:48|7757k  176k|1.0 5.3   0|1884k   26k:1147k   58k:2761k   32k
[...]
17-07 20:57:18|6917k  120k|0.3 4.1   0|  56k  410B:  65k 4506B: 213k 4506B
17-07 20:57:48|5698k  103k|0.1 4.0   0|   0   410B:  27k 6007B: 590k 6007B
17-07 20:58:18|6582k  117k|0.2 4.0   0| 229k   20k: 195k  956B: 290k   21k
17-07 20:58:48|6048k  110k|0.6 4.0 0.1|  32k   21k:  81k  410B: 331k   21k
17-07 20:59:18|8057k  138k|0.6 4.1   0|  42k 5871B:  33k  410B:  35k 5871B
17-07 20:59:48|7369k  145k|0.5 4.1   0|  59k 3959B: 230k  410B: 532k 3959B
17-07 21:00:18|8189k  140k|0.7 4.0   0|  53k 6007B:  58k  410B:  40k 6007B
17-07 21:00:48|7596k  137k|0.3 4.2   0|  24k 6690B: 250k  410B:  15k 5734B
17-07 21:01:18|8448k  145k|0.7 4.2   0|  24k 1365B: 325k 6827B:  15k 7646B
17-07 21:01:48|6821k  119k|0.3 4.0   0|  17k  410B: 175k 3004B:  11k 3004B
17-07 21:02:18|3614k   66k|0.7 2.7   0|  39k  410B: 538k 4779B:  45k 4779B
17-07 21:02:48| 417k   14k|0.5 1.3 0.3| 106k 1638B: 209k 4779B:   0  4779B
17-07 21:03:18| 353k 7979B|0.8 1.2   0|   0  1229B: 449k 2867B:   0  2867B
17-07 21:03:48| 327k 8981B|1.1 1.2   0|   0   410B: 686k 4506B:  43k 4506B
[...]
18-07 11:02:48| 243k 4866B|0.0 1.2 0.1|   0  2458B:   0  3550B:   0  3550B
18-07 11:03:18| 274k 5506B|0.1 1.2 0.1|   0  1775B:   0  3550B:   0  3550B
18-07 11:03:48| 238k 4851B|0.1 1.2 0.0|   0  4369B:   0  3550B:   0  3550B
18-07 11:04:18| 243k 4999B|0.1 1.1 0.1|   0  4506B:   0  3550B:   0  3550B
18-07 11:04:48| 288k 6488B|0.1 1.1 0.4|   0  2458B:   0  3550B:   0  3550B


Because that's after the week-end, there's not much to write.
What's holding 3 of the backups is actually writing log data
like "xx% Completed".

Actively  running at the moment are 1 rsync and 3 ntfsclone.

# strace -tt -s 2 -Te write -p 8771 -p 8567 -p 8856 -p 8403
Process 8771 attached - interrupt to quit
Process 8567 attached - interrupt to quit
Process 8856 attached - interrupt to quit
Process 8403 attached - interrupt to quit
[pid  8403] 11:12:26.539830 write(4, "es"..., 1024 <unfinished ...>
[pid  8771] 11:12:26.540417 write(4, "hb"..., 4096 <unfinished ...>
[pid  8567] 11:12:26.555211 write(1, " 3"..., 25 <unfinished ...>
[pid  8856] 11:12:26.593232 write(1, " 6"..., 25 <unfinished ...>
[pid  8403] 11:12:30.635257 <... write resumed> ) = 1024 <4.095271>
[pid  8403] 11:12:30.635309 write(4, "19"..., 112 <unfinished ...>
[pid  8567] 11:12:30.635364 <... write resumed> ) = 25 <4.080091>
[pid  8856] 11:12:30.635553 <... write resumed> ) = 25 <4.042268>
[pid  8771] 11:12:30.635799 <... write resumed> ) = 4096 <4.095350>
[pid  8771] 11:12:30.636182 write(4, "hb"..., 4096 <unfinished ...>
[pid  8567] 11:12:30.649904 write(1, " 3"..., 25 <unfinished ...>
[pid  8403] 11:12:30.651452 <... write resumed> ) = 112 <0.015921>
[pid  8567] 11:12:30.651595 <... write resumed> ) = 25 <0.001640>
[pid  8403] 11:12:30.651787 write(4, "@d"..., 1024 <unfinished ...>
[pid  8771] 11:12:30.651865 <... write resumed> ) = 4096 <0.015638>
[pid  8771] 11:12:30.652281 write(4, "hb"..., 4096 <unfinished ...>
[pid  8856] 11:12:30.657579 write(1, " 6"..., 25 <unfinished ...>
[pid  8567] 11:12:30.691113 write(1, " 3"..., 25 <unfinished ...>
[pid  8403] 11:12:34.747526 <... write resumed> ) = 1024 <4.095421>
[pid  8403] 11:12:34.747585 write(4, "oo"..., 112 <unfinished ...>
[pid  8856] 11:12:34.747640 <... write resumed> ) = 25 <4.090004>
[pid  8567] 11:12:34.747662 <... write resumed> ) = 25 <4.056499>
[pid  8771] 11:12:34.747698 <... write resumed> ) = 4096 <4.095385>
[pid  8771] 11:12:34.748054 write(4, "hb"..., 4096 <unfinished ...>
[pid  8567] 11:12:34.765660 write(1, " 3"..., 25 <unfinished ...>
[pid  8856] 11:12:34.823355 write(1, " 6"..., 25 <unfinished ...>
[pid  8771] 11:12:38.843269 <... write resumed> ) = 4096 <4.095149>
[pid  8403] 11:12:38.843315 <... write resumed> ) = 112 <4.095707>
[pid  8403] 11:12:38.843358 write(4, "mE"..., 1024 <unfinished ...>
[pid  8856] 11:12:38.843502 <... write resumed> ) = 25 <4.020080>
[pid  8567] 11:12:38.843529 <... write resumed> ) = 25 <4.077820>
[pid  8771] 11:12:38.843759 write(4, "hb"..., 4096 <unfinished ...>
[pid  8856] 11:12:38.883637 write(1, " 6"..., 25 <unfinished ...>
[pid  8567] 11:12:38.917770 write(1, " 3"..., 25 <unfinished ...>

When write(2) takes more than a few miliseconds, it's always
just about 4 seconds.

Just as I'm writing this, it recovered again. Again after one of
the processes finished (this time I can tell it's a ntfsclone,
last time, it looked as if it was after an rsync finished but I
can't be sure)

The ntfsclones do lseek and read on an nbd device, check a
checksum on a mmapped file (on btrfs) and if the checksum
doesn't match a lseek and write on a file on btrfs, standard
output and error to a file on btrfs as well (different
subvolume, same as the sum file). (yes, I know it's not network
bandwidth efficient).

Any idea how I could investigate this any further? Of all the
btrfs issues I've had for that backup system, that's the worse
as it renders the whole system unusable as nightly backups last
over 24 hours.

Cheers,
Stephane
