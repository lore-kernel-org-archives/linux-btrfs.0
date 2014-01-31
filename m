Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f173.google.com ([209.85.216.173]:62840 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbaAaGlI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Jan 2014 01:41:08 -0500
Received: by mail-qc0-f173.google.com with SMTP id i8so6505180qcq.32
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Jan 2014 22:41:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CABgvyo-rw8To-=8_Kt+j8gXiJyX43oWPrWxhAGWqhpE83oCCAw@mail.gmail.com>
References: <CABgvyo-rw8To-=8_Kt+j8gXiJyX43oWPrWxhAGWqhpE83oCCAw@mail.gmail.com>
From: =?UTF-8?Q?Johan_Kr=C3=B6ckel?= <johan.kroeckel@gmail.com>
Date: Fri, 31 Jan 2014 07:40:25 +0100
Message-ID: <CABgvyo9mB=wx2tznWppkfgUs6+YD+761uN45BgUxMh4TgXUKUg@mail.gmail.com>
Subject: Re: lost with degraded RAID1
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry, I failed using this list in conjunction with gmail and send
most answers to respectively duncan and chris directly.

So I sum it up here again:
> What do you get for:
> lsblk
> blkid
> btrfs device scan --all-devices
> btrfs fi show
root@fortknox:/# lsblk
NAME               MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINT
sda                  8:0    0 232,9G  0 disk
└─sda1               8:1    0 232,9G  0 part  /
sdb                  8:16   0   1,8T  0 disk
└─sdb1               8:17   0   1,8T  0 part
  └─bunkerA (dm-0) 253:0    0   1,8T  0 crypt
sdc                  8:32   0   2,7T  0 disk
└─sdc1               8:33   0   2,7T  0 part  /USBPLATTE
loop1                7:1    0   500G  0 loop
root@fortknox:/# blkid
/dev/sda1: UUID="d055ffe7-80ed-455e-8117-4a2c8bef3ed5" TYPE="ext4"
/dev/sdc1: UUID="812c784b-df5a-48a6-98ff-5b755e29b563" TYPE="ext4"
/dev/sdb1: UUID="947206e2-488e-4dc4-b243-912901512ed4" TYPE="crypto_LUKS"
/dev/mapper/bunkerA: LABEL="bunker"
UUID="7f954a85-7566-4251-832c-44f2d3de2211"
UUID_SUB="6c66c3c1-df8f-4b29-9acb-bd923a69b3ee" TYPE="btrfs"
root@fortknox:/# btrfs device scan --all-devices
Scanning for Btrfs filesystems
root@fortknox:/# btrfs fi show
Label: 'bunker'  uuid: 7f954a85-7566-4251-832c-44f2d3de2211
        Total devices 2 FS bytes used 1.58TiB
        devid    2 size 1.82TiB used 1.59TiB path /dev/mapper/bunkerA
        *** Some devices missing

Btrfs v3.12

>> But now, I can't mount bunkerA degraded,RW because degraded
>> filesystems are not allowed to be mounted RW (?)
>
> Have you tried? What errors do you get in user space and dmesg?
root@fortknox:/# umount /mnt
umount: /mnt: not mounted
root@fortknox:/# mount -odegraded,rw /dev/mapper/bunkerA /mnt
mount: wrong fs type, bad option, bad superblock on /dev/mapper/bunkerA,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

root@fortknox:/# dmesg|tail
[756751.574065] btrfs: bdev (null) errs: wr 1375454, rd 186442, flush
0, corrupt 0, gen 0
[756751.837133] Btrfs: too many missing devices, writeable mount is not allowed
[756751.865278] btrfs: open_ctree failed
[781332.902000] btrfs: device label bunker devid 2 transid 121487 /dev/dm-0
[781630.561889] btrfs: device label bunker devid 2 transid 121487
/dev/mapper/bunkerA
[781630.564673] btrfs: allowing degraded mounts
[781630.564684] btrfs: disk space caching is enabled
[781630.598155] btrfs: bdev (null) errs: wr 1375454, rd 186442, flush
0, corrupt 0, gen 0
[781630.816989] Btrfs: too many missing devices, writeable mount is not allowed
[781630.842901] btrfs: open_ctree failed




root@fortknox:/# mount  -odegraded,recovery,skip_balance
/dev/mapper/bunkerA /mnt
mount: wrong fs type, bad option, bad superblock on /dev/mapper/bunkerA,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

root@fortknox:/# dmesg|tail
[781630.598155] btrfs: bdev (null) errs: wr 1375454, rd 186442, flush
0, corrupt 0, gen 0
[781630.816989] Btrfs: too many missing devices, writeable mount is not allowed
[781630.842901] btrfs: open_ctree failed
[781781.311741] btrfs: device label bunker devid 2 transid 121487
/dev/mapper/bunkerA
[781781.314204] btrfs: allowing degraded mounts
[781781.314219] btrfs: enabling auto recovery
[781781.314227] btrfs: disk space caching is enabled
[781781.348118] btrfs: bdev (null) errs: wr 1375454, rd 186442, flush
0, corrupt 0, gen 0
[781781.572222] Btrfs: too many missing devices, writeable mount is not allowed
[781781.597722] btrfs: open_ctree failed





But (i think) read and write errors are not increasing. I dont know
whether this is because of the missing drive or because the filesystem
has never been mounted writeable since a point in time.

root@fortknox:~# btrfs-show-super -a /dev/mapper/bunkerA
superblock: bytenr=65536, device=/dev/mapper/bunkerA
---------------------------------------------------------
csum 0x40e23443 [match]
bytenr 65536
flags 0x1
magic _BHRfS_M [match]
fsid 7f954a85-7566-4251-832c-44f2d3de2211
label bunker
generation 121487
root 1888523018240
sys_array_size 129
chunk_root_generation 121477
root_level 2
chunk_root 3304906031104
chunk_root_level 1
log_root 0
log_root_transid 0
log_root_level 0
total_bytes 4000791559680
bytes_used 1743686074368
sectorsize 4096
nodesize 4096
leafsize 4096
stripesize 4096
root_dir 6
num_devices 2
compat_flags 0x0
compat_ro_flags 0x0
incompat_flags 0x1
csum_type 0
csum_size 4
cache_generation 121487
uuid_tree_generation 121487
dev_item.uuid 6c66c3c1-df8f-4b29-9acb-bd923a69b3ee
dev_item.fsid 7f954a85-7566-4251-832c-44f2d3de2211 [match]
dev_item.type 0
dev_item.total_bytes 2000395771392
dev_item.bytes_used 1746986336256
dev_item.io_align 4096
dev_item.io_width 4096
dev_item.sector_size 4096
dev_item.devid 2
dev_item.dev_group 0
dev_item.seek_speed 0
dev_item.bandwidth 0
dev_item.generation 0

superblock: bytenr=67108864, device=/dev/mapper/bunkerA
---------------------------------------------------------
csum 0xe0831c8d [match]
bytenr 67108864
flags 0x1
magic _BHRfS_M [match]
fsid 7f954a85-7566-4251-832c-44f2d3de2211
label bunker
generation 121487
root 1888523018240
sys_array_size 129
chunk_root_generation 121477
root_level 2
chunk_root 3304906031104
chunk_root_level 1
log_root 0
log_root_transid 0
log_root_level 0
total_bytes 4000791559680
bytes_used 1743686074368
sectorsize 4096
nodesize 4096
leafsize 4096
stripesize 4096
root_dir 6
num_devices 2
compat_flags 0x0
compat_ro_flags 0x0
incompat_flags 0x1
csum_type 0
csum_size 4
cache_generation 121487
uuid_tree_generation 121487
dev_item.uuid 6c66c3c1-df8f-4b29-9acb-bd923a69b3ee
dev_item.fsid 7f954a85-7566-4251-832c-44f2d3de2211 [match]
dev_item.type 0
dev_item.total_bytes 2000395771392
dev_item.bytes_used 1746986336256
dev_item.io_align 4096
dev_item.io_width 4096
dev_item.sector_size 4096
dev_item.devid 2
dev_item.dev_group 0
dev_item.seek_speed 0
dev_item.bandwidth 0
dev_item.generation 0

superblock: bytenr=274877906944, device=/dev/mapper/bunkerA
---------------------------------------------------------
csum 0x1d044abc [match]
bytenr 274877906944
flags 0x1
magic _BHRfS_M [match]
fsid 7f954a85-7566-4251-832c-44f2d3de2211
label bunker
generation 121487
root 1888523018240
sys_array_size 129
chunk_root_generation 121477
root_level 2
chunk_root 3304906031104
chunk_root_level 1
log_root 0
log_root_transid 0
log_root_level 0
total_bytes 4000791559680
bytes_used 1743686074368
sectorsize 4096
nodesize 4096
leafsize 4096
stripesize 4096
root_dir 6
num_devices 2
compat_flags 0x0
compat_ro_flags 0x0
incompat_flags 0x1
csum_type 0
csum_size 4
cache_generation 121487
uuid_tree_generation 121487
dev_item.uuid 6c66c3c1-df8f-4b29-9acb-bd923a69b3ee
dev_item.fsid 7f954a85-7566-4251-832c-44f2d3de2211 [match]
dev_item.type 0
dev_item.total_bytes 2000395771392
dev_item.bytes_used 1746986336256
dev_item.io_align 4096
dev_item.io_width 4096
dev_item.sector_size 4096
dev_item.devid 2
dev_item.dev_group 0
dev_item.seek_speed 0
dev_item.bandwidth 0
dev_item.generation 0




root@fortknox:~# btrfsck /dev/mapper/bunkerA
warning, device 1 is missing
warning devid 1 not found already
Checking filesystem on /dev/mapper/bunkerA
UUID: 7f954a85-7566-4251-832c-44f2d3de2211
checking extents
checking free space cache
Error reading 1647012864000, -1
Error reading 1647819816960, -1
Error reading 1647965962240, -1
Error reading 1647006314496, -1
Error reading 2778306510848, -1
Error reading 1655481655296, -1
Error reading 1655482179584, -1
Error reading 1655493296128, -1
Error reading 1788748169216, -1
Error reading 1644927381504, -1
Error reading 1671399948288, -1
Error reading 1646999830528, -1
Error reading 1647013462016, -1
Error reading 1738282172416, -1
Error reading 1648014381056, -1
Error reading 1655474946048, -1
Error reading 2778315161600, -1
failed to load free space cache for block group 1644867616768failed to
load free space cache for block group 1645941358592failed to load free
space cache for block group 1647015100416failed to load free space
cache for block group 1654531293184failed to load free space cache for
block group 1657752518656failed to load free space cache for block
group 1658826260480failed to load free space cache for block group
1659900002304failed to load free space cache for block group
1667416195072failed to load free space cache for block group
1670637420544failed to load free space cache for block group
1676006129664failed to load free space cache for block group
1681374838784failed to load free space cache for block group
1695333482496failed to load free space cache for block group
1698554707968failed to load free space cache for block group
1699628449792failed to load free space cache for block group
1700702191616failed to load free space cache for block group
1703923417088failed to load free space cache for block group Error
reading 2778315685888, -1
Error reading 2778315948032, -1
Error reading 2778316210176, -1
Error reading 2778316472320, -1
Error reading 2778317520896, -1
Error reading 2778318307328, -1
Error reading 2778318569472, -1
Error reading 2778320142336, -1
Error reading 2778320404480, -1
Error reading 2778320666624, -1
Error reading 1937998594048, -1
Error reading 1646997389312, -1
Error reading 1794117312512, -1
Error reading 1647971205120, -1
Error reading 1655480606720, -1
Error reading 1655481917440, -1
Error reading 1968063332352, -1
1715734577152failed to load free space cache for block group
1726471995392failed to load free space cache for block group
1742578122752failed to load free space cache for block group
1745799348224failed to load free space cache for block group
1752241799168failed to load free space cache for block group
1753315540992failed to load free space cache for block group
1758684250112failed to load free space cache for block group
1761905475584failed to load free space cache for block group
1762979217408failed to load free space cache for block group
1766200442880failed to load free space cache for block group
1774790377472failed to load free space cache for block group
1775864119296failed to load free space cache for block group
1780159086592failed to load free space cache for block group
1781232828416failed to load free space cache for block group
1782306570240failed to load free space cache for block group
1783380312064failed to load free space cache for block group
1786601537536failed to load free space cache forError reading
1655482441728, -1
Error reading 1655482949632, -1
Error reading 1975579820032, -1
Error reading 1646999044096, -1
Error reading 2099058638848, -1
Error reading 1655506403328, -1
Error reading 1661504389120, -1
Error reading 1747946557440, -1
Error reading 1752241340416, -1
Error reading 1766200131584, -1
Error reading 1769420718080, -1
Error reading 1776937304064, -1
Error reading 1778010673152, -1
Error reading 1778010935296, -1
Error reading 1784452825088, -1
Error reading 1786600423424, -1
Error reading 1787673284608, -1
 block group 1787675279360failed to load free space cache for block
group 1788749021184failed to load free space cache for block group
1789822763008failed to load free space cache for block group
1790896504832failed to load free space cache for block group
1791970246656failed to load free space cache for block group
1794117730304failed to load free space cache for block group
1795191472128failed to load free space cache for block group
1796265213952failed to load free space cache for block group
1797338955776failed to load free space cache for block group
1798412697600failed to load free space cache for block group
1799486439424failed to load free space cache for block group
1800560181248failed to load free space cache for block group
1801633923072failed to load free space cache for block group
1802707664896failed to load free space cache for block group
1803781406720failed to load free space cache for block group
1804855148544failed to load free space cache for block group
1805928890368failed to load free spError reading 1787674857472, -1
Error reading 1768347648000, -1
Error reading 1645348323328, -1
Error reading 1671399424000, -1
Error reading 1647011557376, -1
Error reading 1661503520768, -1
Error reading 1811296747520, -1
Error reading 1992759660544, -1
Error reading 2778269958144, -1
Error reading 2099059163136, -1
Error reading 3065128484864, -1
Error reading 1720028954624, -1
Error reading 1778011197440, -1
Error reading 1920818544640, -1
Error reading 1937998856192, -1
Error reading 1947662532608, -1
Error reading 2474869772288, -1
ace cache for block group 1807002632192failed to load free space cache
for block group 1808076374016failed to load free space cache for block
group 1810223857664failed to load free space cache for block group
1813445083136failed to load free space cache for block group
1815592566784failed to load free space cache for block group
1816666308608failed to load free space cache for block group
1818813792256failed to load free space cache for block group
1820961275904failed to load free space cache for block group
1827403726848failed to load free space cache for block group
1828477468672failed to load free space cache for block group
1829551210496failed to load free space cache for block group
1830624952320failed to load free space cache for block group
1832772435968failed to load free space cache for block group
1834919919616failed to load free space cache for block group
1835993661440failed to load free space cache for block group
1843509854208failed to load free space cache for block group
1844583596032failed toError reading 1721102303232, -1
Error reading 1957325766656, -1
Error reading 2164558200832, -1
Error reading 1912229044224, -1
Error reading 3099322155008, -1
Error reading 2778243129344, -1
Error reading 2150599700480, -1
Error reading 2163484598272, -1
Error reading 1722176700416, -1
Error reading 3099324702720, -1
Error reading 2099058900992, -1
Error reading 2778206109696, -1
Error reading 2778271531008, -1
Error reading 1646997127168, -1
Error reading 2499565780992, -1
Error reading 2099059609600, -1
 load free space cache for block group 1845657337856failed to load
free space cache for block group 1846731079680failed to load free
space cache for block group 1849952305152failed to load free space
cache for block group 1851026046976failed to load free space cache for
block group 1854247272448failed to load free space cache for block
group 1857468497920failed to load free space cache for block group
1858542239744failed to load free space cache for block group
1859615981568failed to load free space cache for block group
1863910948864failed to load free space cache for block group
1866058432512failed to load free space cache for block group
1872500883456failed to load free space cache for block group
1874648367104failed to load free space cache for block group
1880017076224failed to load free space cache for block group
1882164559872failed to load free space cache for block group
1887533268992failed to load free space cache for block group
1888607010816failed to load free space cache for block group
188968075Error reading 2080806600704, -1
Error reading 1671398899712, -1
Error reading 2257973387264, -1
Error reading 2173148192768, -1
Error reading 2500639551488, -1
Error reading 3222112632832, -1
Error reading 1941220032512, -1
Error reading 2049667981312, -1
Error reading 1646987771904, -1
Error reading 1743650672640, -1
Error reading 1943366107136, -1
Error reading 2778275590144, -1
Error reading 1644910018560, -1
Error reading 2778272055296, -1
Error reading 2778272317440, -1
Error reading 3211456638976, -1
Error reading 1749019860992, -1
2640failed to load free space cache for block group
1890754494464failed to load free space cache for block group
1891828236288failed to load free space cache for block group
1893975719936failed to load free space cache for block group
1895049461760failed to load free space cache for block group
1909008105472failed to load free space cache for block group
1911155589120failed to load free space cache for block group
1912229330944failed to load free space cache for block group
1917598040064failed to load free space cache for block group
1919745523712failed to load free space cache for block group
1925114232832failed to load free space cache for block group
1931556683776failed to load free space cache for block group
1936925392896failed to load free space cache for block group
1937999134720failed to load free space cache for block group
1939072876544failed to load free space cache for block group
1940146618368failed to load free space cache for block group
1944441585664failed to load free space cache for block grError reading
2147378200576, -1
Error reading 1959473307648, -1
Error reading 2109797539840, -1
Error reading 2398634049536, -1
Error reading 3075524984832, -1
Error reading 2873227935744, -1
Error reading 2139862138880, -1
Error reading 2895542550528, -1
Error reading 2165631942656, -1
Error reading 2778217775104, -1
Error reading 2778272841728, -1
Error reading 2235425173504, -1
Error reading 2778277281792, -1
Error reading 2150599438336, -1
Error reading 2313807921152, -1
Error reading 1945514999808, -1
Error reading 2538220527616, -1
oup 1945515327488failed to load free space cache for block group
1946589069312failed to load free space cache for block group
1953031520256failed to load free space cache for block group
1956252745728failed to load free space cache for block group
1958400229376failed to load free space cache for block group
1959473971200failed to load free space cache for block group
1960547713024failed to load free space cache for block group
1966990163968failed to load free space cache for block group
1971285131264failed to load free space cache for block group
1974506356736failed to load free space cache for block group
1978801324032failed to load free space cache for block group
1983096291328failed to load free space cache for block group
1985243774976failed to load free space cache for block group
1987391258624failed to load free space cache for block group
1990612484096failed to load free space cache for block group
1991686225920failed to load free space cache for block group
2005644869632failed to load free space cacheError reading
2645594722304, -1
Error reading 1782306279424, -1
Error reading 2944094769152, -1
Error reading 1647003238400, -1
Error reading 2778243915776, -1
Error reading 2778210566144, -1
Error reading 2778244177920, -1
Error reading 2273005338624, -1
Error reading 2256900136960, -1
Error reading 3203940081664, -1
Error reading 2280522493952, -1
Error reading 3257540214784, -1
Error reading 2596202586112, -1
Error reading 2240794132480, -1
Error reading 2778308608000, -1
Error reading 2849604960256, -1
Error reading 3005297262592, -1
 for block group 2008866095104failed to load free space cache for
block group 2028193447936failed to load free space cache for block
group 2030340931584failed to load free space cache for block group
2035709640704failed to load free space cache for block group
2038930866176failed to load free space cache for block group
2043225833472failed to load free space cache for block group
2046447058944failed to load free space cache for block group
2047520800768failed to load free space cache for block group
2048594542592failed to load free space cache for block group
2057184477184failed to load free space cache for block group
2061479444480failed to load free space cache for block group
2064700669952failed to load free space cache for block group
2065774411776failed to load free space cache for block group
2068995637248failed to load free space cache for block group
2071143120896failed to load free space cache for block group
2072216862720failed to load free space cache for block group
2082954280960failed to load freError reading 1647005265920, -1
Error reading 3051468955648, -1
Error reading 2273006305280, -1
Error reading 3099324964864, -1
Error reading 2276227534848, -1
Error reading 2247236485120, -1
Error reading 2908661415936, -1
Error reading 3060058935296, -1
Error reading 2778244440064, -1
Error reading 2987044610048, -1
Error reading 3337841999872, -1
Error reading 1751167737856, -1
Error reading 1647006646272, -1
Error reading 1825255927808, -1
Error reading 3099325227008, -1
Error reading 3133073588224, -1
Error reading 2842089160704, -1
e space cache for block group 2084028022784failed to load free space
cache for block group 2085101764608failed to load free space cache for
block group 2090470473728failed to load free space cache for block
group 2092617957376failed to load free space cache for block group
2093691699200failed to load free space cache for block group
2096912924672failed to load free space cache for block group
2097986666496failed to load free space cache for block group
2102281633792failed to load free space cache for block group
2108724084736failed to load free space cache for block group
2109797826560failed to load free space cache for block group
2110871568384failed to load free space cache for block group
2113019052032failed to load free space cache for block group
2116240277504failed to load free space cache for block group
2121608986624failed to load free space cache for block group
2123756470272failed to load free space cache for block group
2136641372160failed to load free space cache for block group
2146305048576faileError reading 3203940343808, -1
Error reading 2300923604992, -1
Error reading 2842089422848, -1
Error reading 3209145024512, -1
Error reading 2945168691200, -1
Error reading 2924767465472, -1
Error reading 2917251407872, -1
Error reading 2353536950272, -1
Error reading 1809149812736, -1
Error reading 3101692198912, -1
Error reading 2778244702208, -1
Error reading 3101692461056, -1
Error reading 3101692723200, -1
Error reading 2778267860992, -1
Error reading 3099325489152, -1
Error reading 2598350065664, -1
d to load free space cache for block group 2148452532224failed to load
free space cache for block group 2149526274048failed to load free
space cache for block group 2154894983168failed to load free space
cache for block group 2155968724992failed to load free space cache for
block group 2157042466816failed to load free space cache for block
group 2159189950464failed to load free space cache for block group
2162411175936failed to load free space cache for block group
2163484917760failed to load free space cache for block group
2164558659584failed to load free space cache for block group
2167779885056failed to load free space cache for block group
2168853626880failed to load free space cache for block group
2169927368704failed to load free space cache for block group
2172074852352failed to load free space cache for block group
2173148594176failed to load free space cache for block group
2175296077824failed to load free space cache for block group
2181738528768failed to load free space cache for block group
21849Error reading 1647008669696, -1
Error reading 2778218299392, -1
Error reading 2778245226496, -1
Error reading 3099326013440, -1
Error reading 2275153801216, -1
Error reading 3078046679040, -1
Error reading 1646993993728, -1
Error reading 3101693247488, -1
Error reading 2999929532416, -1
Error reading 2972012052480, -1
Error reading 2778245488640, -1
Error reading 2778206633984, -1
Error reading 3099327062016, -1
Error reading 3099328110592, -1
Error reading 3099328372736, -1
Error reading 2368569409536, -1
Error reading 2160263286784, -1
59754240failed to load free space cache for block group
2193549688832failed to load free space cache for block group
2194623430656failed to load free space cache for block group
2196770914304failed to load free space cache for block group
2197844656128failed to load free space cache for block group
2199992139776failed to load free space cache for block group
2207508332544failed to load free space cache for block group
2212877041664failed to load free space cache for block group
2215024525312failed to load free space cache for block group
2216098267136failed to load free space cache for block group
2217172008960failed to load free space cache for block group
2218245750784failed to load free space cache for block group
2219319492608failed to load free space cache for block group
2220393234432failed to load free space cache for block group
2225761943552failed to load free space cache for block group
2228983169024failed to load free space cache for block group
2230056910848failed to load free space cache for blocError reading
3099329159168, -1
Error reading 3099330207744, -1
Error reading 2813098323968, -1
Error reading 2778216988672, -1
Error reading 1646990393344, -1
Error reading 2111944982528, -1
Error reading 2203213070336, -1
Error reading 1648066887680, -1
Error reading 2502787137536, -1
Error reading 2777428246528, -1
Error reading 2217171730432, -1
Error reading 2283743698944, -1
Error reading 2778245750784, -1
Error reading 2155968266240, -1
Error reading 2510303260672, -1
Error reading 2711092965376, -1
Error reading 2788402348032, -1
k group 2232204394496failed to load free space cache for block group
2233278136320failed to load free space cache for block group
2234351878144failed to load free space cache for block group
2235425619968failed to load free space cache for block group
2236499361792failed to load free space cache for block group
2237573103616failed to load free space cache for block group
2238646845440failed to load free space cache for block group
2240794329088failed to load free space cache for block group
2244015554560failed to load free space cache for block group
2246163038208failed to load free space cache for block group
2247236780032failed to load free space cache for block group
2248310521856failed to load free space cache for block group
2249384263680failed to load free space cache for block group
2250458005504failed to load free space cache for block group
2252605489152failed to load free space cache for block group
2253679230976failed to load free space cache for block group
2254752972800failed to load free space cError reading 2543589195776,
-1
Error reading 2970937540608, -1
Error reading 2996708245504, -1
Error reading 1701765120000, -1
Error reading 2778246012928, -1
Error reading 2623046090752, -1
Error reading 2777427148800, -1
Error reading 2917250883584, -1
Error reading 2917251145728, -1
Error reading 3013888114688, -1
Error reading 1788747644928, -1
Error reading 2365347962880, -1
Error reading 3054690205696, -1
Error reading 2918324613120, -1
Error reading 2777427722240, -1
Error reading 2777428508672, -1
Error reading 2961274667008, -1
ache for block group 2255826714624failed to load free space cache for
block group 2256900456448failed to load free space cache for block
group 2257974198272failed to load free space cache for block group
2259047940096failed to load free space cache for block group
2260121681920failed to load free space cache for block group
2263342907392failed to load free space cache for block group
2264416649216failed to load free space cache for block group
2271932841984failed to load free space cache for block group
2273006583808failed to load free space cache for block group
2274080325632failed to load free space cache for block group
2275154067456failed to load free space cache for block group
2277301551104failed to load free space cache for block group
2278375292928failed to load free space cache for block group
2282670260224failed to load free space cache for block group
2283744002048failed to load free space cache for block group
2284817743872failed to load free space cache for block group
2299850129408failed to loadError reading 3033215467520, -1
Error reading 3076165009408, -1
Error reading 2778280181760, -1
Error reading 3099331256320, -1
Error reading 1738281648128, -1
Error reading 3099340431360, -1
Error reading 2777431654400, -1
Error reading 2973085794304, -1
Error reading 2777426886656, -1
Error reading 2923693670400, -1
Error reading 3099340693504, -1
Error reading 3099340955648, -1
Error reading 2537146613760, -1
Error reading 3099341479936, -1
Error reading 3020330565632, -1
Error reading 3025699323904, -1
Error reading 2975232884736, -1
 free space cache for block group 2312735031296failed to load free
space cache for block group 2319177482240failed to load free space
cache for block group 2320251224064failed to load free space cache for
block group 2321324965888failed to load free space cache for block
group 2326693675008failed to load free space cache for block group
2327767416832failed to load free space cache for block group
2328841158656failed to load free space cache for block group
2352463478784failed to load free space cache for block group
2354610962432failed to load free space cache for block group
2355684704256failed to load free space cache for block group
2364274638848failed to load free space cache for block group
2376085798912failed to load free space cache for block group
2378233282560failed to load free space cache for block group
2384675733504failed to load free space cache for block group
2386823217152failed to load free space cache for block group
2397560635392failed to load free space cache for block group
2408298053632fError reading 1791968215040, -1
Error reading 1647009984512, -1
Error reading 2929062400000, -1
Error reading 2149525815296, -1
Error reading 1646985674752, -1
Error reading 3029994242048, -1
Error reading 2778207158272, -1
Error reading 3079048380416, -1
Error reading 3058985140224, -1
Error reading 3074017714176, -1
Error reading 2778224590848, -1
Error reading 3099342528512, -1
Error reading 3099342790656, -1
Error reading 2157042008064, -1
Error reading 2778225901568, -1
Error reading 3209144762368, -1
ailed to load free space cache for block group 2420109213696failed to
load free space cache for block group 2427625406464failed to load free
space cache for block group 2439436566528failed to load free space
cache for block group 2440510308352failed to load free space cache for
block group 2441584050176failed to load free space cache for block
group 2451247726592failed to load free space cache for block group
2473796304896failed to load free space cache for block group
2478091272192failed to load free space cache for block group
2479165014016failed to load free space cache for block group
2498492366848failed to load free space cache for block group
2499566108672failed to load free space cache for block group
2509229785088failed to load free space cache for block group
2515672236032failed to load free space cache for block group
2530704621568failed to load free space cache for block group
2534999588864failed to load free space cache for block group
2542515781632failed to load free space cache for block group 2Error
reading 2778230095872, -1
Error reading 2777433219072, -1
Error reading 2778207420416, -1
Error reading 1655478509568, -1
Error reading 1646986199040, -1
Error reading 3217720803328, -1
Error reading 3222111846400, -1
Error reading 2778305724416, -1
Error reading 2778229309440, -1
Error reading 2778270220288, -1
Error reading 2778277560320, -1
Error reading 2882891501568, -1
Error reading 2778219085824, -1
Error reading 2778226163712, -1
Error reading 1646986723328, -1
Error reading 1646986985472, -1
Error reading 1646987247616, -1
546810748928failed to load free space cache for block group
2570433069056failed to load free space cache for block group
2571506810880failed to load free space cache for block group
2573654294528failed to load free space cache for block group
2582244229120failed to load free space cache for block group
2585465454592failed to load free space cache for block group
2595129131008failed to load free space cache for block group
2597276614656failed to load free space cache for block group
2620898934784failed to load free space cache for block group
2621972676608failed to load free space cache for block group
2632710094848failed to load free space cache for block group
2661701124096failed to load free space cache for block group
2686397186048failed to load free space cache for block group
2688544669696failed to load free space cache for block group
2718609440768failed to load free space cache for block group
2752969179136failed to load free space cache for block group
2758337888256failed to load free space cache for Error reading
3099343052800, -1
Error reading 1728619188224, -1
Error reading 3079048642560, -1
Error reading 1647012601856, -1
Error reading 1786600161280, -1
Error reading 1655494344704, -1
Error reading 2778308083712, -1
Error reading 2778310180864, -1
Error reading 1644921614336, -1
Error reading 2778312540160, -1
Error reading 1683453624320, -1
Error reading 1797337710592, -1
Error reading 1645331808256, -1
Error reading 3209129295872, -1
Error reading 2998855598080, -1
Error reading 2787328196608, -1
Error reading 2831352135680, -1
block group 2759411630080failed to load free space cache for block
group 2773370273792failed to load free space cache for block group
2774444015616failed to load free space cache for block group
2775517757440failed to load free space cache for block group
2776591499264failed to load free space cache for block group
2777665241088failed to load free space cache for block group
2778738982912failed to load free space cache for block group
2779812724736failed to load free space cache for block group
2780886466560failed to load free space cache for block group
2786255175680failed to load free space cache for block group
2789476401152failed to load free space cache for block group
2795918852096failed to load free space cache for block group
2807730012160failed to load free space cache for block group
2810951237632failed to load free space cache for block group
2812024979456failed to load free space cache for block group
2841016008704failed to load free space cache for block group
2847458459648failed to load free spaError reading 1645349634048, -1
Error reading 2883965411328, -1
Error reading 2837794250752, -1
Error reading 2970937802752, -1
Error reading 3099362435072, -1
Error reading 1646997995520, -1
Error reading 2877522681856, -1
Error reading 3222112894976, -1
Error reading 2778232455168, -1
Error reading 3066863624192, -1
ce cache for block group 2860343361536failed to load free space cache
for block group 2862490845184failed to load free space cache for block
group 2865712070656failed to load free space cache for block group
2873228263424failed to load free space cache for block group
2876449488896failed to load free space cache for block group
2882891939840failed to load free space cache for block group
2883965681664failed to load free space cache for block group
2885039423488failed to load free space cache for block group
2886113165312failed to load free space cache for block group
2889334390784failed to load free space cache for block group
2890408132608free space inode generation (0) did not match free space
cache generation (20905)
Error reading 1661505437696, -1
Error reading 2165631680512, -1
Error reading 2778314375168, -1
Error reading 2778314899456, -1
Error reading 1646988296192, -1
Error reading 2318103281664, -1
Error reading 2778318045184, -1
Error reading 3066863886336, -1
Error reading 3099360862208, -1
Error reading 1646989869056, -1
Error reading 3066864148480, -1
Error reading 1647005597696, -1
Error reading 3099361124352, -1
Error reading 1646992752640, -1
Error reading 1655480868864, -1
Error reading 1644921085952, -1
Error reading 2891481677824, -1
failed to load free space cache for block group 2894703099904failed to
load free space cache for block group 2900071809024failed to load free
space cache for block group 2902219292672failed to load free space
cache for block group 2903293034496failed to load free space cache for
block group 2910809227264failed to load free space cache for block
group 2912956710912failed to load free space cache for block group
2914030452736failed to load free space cache for block group
2915104194560failed to load free space cache for block group
2917251678208failed to load free space cache for block group
2921546645504failed to load free space cache for block group
2922620387328failed to load free space cache for block group
2924767870976failed to load free space cache for block group
2925841612800failed to load free space cache for block group
2926915354624failed to load free space cache for block group
2930136580096failed to load free space cache for block group
2931210321920failed to load free space cache for block group Error
reading 2916176310272, -1
Error reading 3038584225792, -1
Error reading 3046100369408, -1
Error reading 1647972515840, -1
Error reading 2923693408256, -1
Error reading 1645349109760, -1
Error reading 3058345299968, -1
Error reading 1988464431104, -1
Error reading 3058346348544, -1
Error reading 1647004549120, -1
Error reading 2951610437632, -1
Error reading 3099360337920, -1
Error reading 2994560761856, -1
Error reading 2997781913600, -1
Error reading 2348168204288, -1
Error reading 3066864934912, -1
Error reading 1644895338496, -1
2936579031040failed to load free space cache for block group
2940873998336failed to load free space cache for block group
2944095223808failed to load free space cache for block group
2948390191104failed to load free space cache for block group
2950537674752failed to load free space cache for block group
2954832642048failed to load free space cache for block group
2956980125696failed to load free space cache for block group
2964496318464failed to load free space cache for block group
2965570060288failed to load free space cache for block group
2969865027584failed to load free space cache for block group
2973086253056failed to load free space cache for block group
2975233736704failed to load free space cache for block group
2977381220352failed to load free space cache for block group
2980602445824failed to load free space cache for block group
2988118638592failed to load free space cache for block group
2990266122240failed to load free space cache for block group
2993487347712failed to load free space cache forError reading
3066865197056, -1
Error reading 1646989344768, -1
Error reading 2999929008128, -1
Error reading 2887186579456, -1
Error reading 1655477182464, -1
Error reading 1645349371904, -1
Error reading 3099361386496, -1
Error reading 1671399686144, -1
Error reading 3005297000448, -1
Error reading 1644915576832, -1
Error reading 1645348847616, -1
Error reading 2379306696704, -1
Error reading 3061920546816, -1
Error reading 3099362172928, -1
Error reading 1647976710144, -1
Error reading 1644915838976, -1
Error reading 1644926586880, -1
 block group 2994561089536failed to load free space cache for block
group 2996708573184failed to load free space cache for block group
2998856056832failed to load free space cache for block group
2999929798656failed to load free space cache for block group
3002077282304failed to load free space cache for block group
3004224765952failed to load free space cache for block group
3005298507776failed to load free space cache for block group
3006372249600failed to load free space cache for block group
3009593475072failed to load free space cache for block group
3013888442368failed to load free space cache for block group
3021404635136failed to load free space cache for block group
3022478376960failed to load free space cache for block group
3036437020672failed to load free space cache for block group
3037510762496failed to load free space cache for block group
3047174438912failed to load free space cache for block group
3066501791744failed to load free space cache for block group
3098714046464failed to load free spError reading 1648000040960, -1
Error reading 1669556535296, -1
Error reading 1671400472576, -1
Error reading 1644917489664, -1
Error reading 1644922470400, -1
Error reading 1644929810432, -1
Error reading 1644925353984, -1
Error reading 1645326041088, -1
Error reading 1647002632192, -1
Error reading 1647004286976, -1
Error reading 1648030711808, -1
Error reading 1647968583680, -1
Error reading 1648054566912, -1
Error reading 1648064790528, -1
Error reading 1648074096640, -1
Error reading 1647985623040, -1
Error reading 1655474683904, -1
ace cache for block group 3099787788288failed to load free space cache
for block group 3100861530112failed to load free space cache for block
group 3169581006848failed to load free space cache for block group
3171728490496failed to load free space cache for block group
3221120614400failed to load free space cache for block group
3222194356224failed to load free space cache for block group
3308135645184failed to load free space cache for block group
3311356870656failed to load free space cache for block group
3312430612480failed to load free space cache for block group
3313504354304failed to load free space cache for block group
3314578096128failed to load free space cache for block group
3315651837952failed to load free space cache for block group
3316725579776failed to load free space cache for block group
3317799321600failed to load free space cache for block group
3319946805248failed to load free space cache for block group
3321020547072failed to load free space cache for block group
3322094288896failed toError reading 1655477985280, -1
Error reading 1655479296000, -1
Error reading 1655499849728, -1
Error reading 1655506927616, -1
Error reading 1671703769088, -1
Error reading 1676003966976, -1
Error reading 1677069975552, -1
Error reading 1699627622400, -1
Error reading 1655479820288, -1
checking fs roots
checking csums
checking root refs
 load free space cache for block group 3323168030720failed to load
free space cache for block group 3324241772544failed to load free
space cache for block group 3325315514368failed to load free space
cache for block group 3326389256192failed to load free space cache for
block group 3327462998016failed to load free space cache for block
group 3328536739840failed to load free space cache for block group
3329610481664failed to load free space cache for block group
3330684223488failed to load free space cache for block group
3350011576320failed to load free space cache for block group
3454164533248found 23759468894 bytes used err is 0
total csum bytes: 1533072864
total tree bytes: 1728692224
total fs tree bytes: 44019712
total extent tree bytes: 47996928
btree space waste bytes: 46886467
file data blocks allocated: 4140676993024
 referenced 1741813084160
Btrfs v3.12
