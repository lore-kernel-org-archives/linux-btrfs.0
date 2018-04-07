Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:44935 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751802AbeDGAg3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Apr 2018 20:36:29 -0400
Received: by mail-wr0-f195.google.com with SMTP id u46so3150364wrc.11
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Apr 2018 17:36:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1401c2e5-d0e9-ac9e-178f-776cb9847ffb@gmx.com>
References: <CAAGPGf9+y_BXj=jQ1aY3xSPzMTjOTWPPO2avBODSYem5pyRXGQ@mail.gmail.com>
 <20180406170329.GH8557@twin.jikos.cz> <1401c2e5-d0e9-ac9e-178f-776cb9847ffb@gmx.com>
From: Ben Parsons <9parsonsb@gmail.com>
Date: Sat, 7 Apr 2018 10:35:46 +1000
Message-ID: <CAAGPGf8m-8qQ-tsW6ZxtEktm1DbP4FfrU6FZr+tX3vb_Cq+9_g@mail.gmail.com>
Subject: Re: Bad magic on superblock on /dev/sda at 65536
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Content-Type: multipart/mixed; boundary="f4f5e80a11d8f7ef9b0569375cee"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--f4f5e80a11d8f7ef9b0569375cee
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

>btrfs inspect-internal dump-super -Ffa /path

superblock: bytenr=3D65536, device=3D/dev/sda
---------------------------------------------------------
csum_type        0 (crc32c)
csum_size        4
csum            0x00000000 [DON'T MATCH]
bytenr            0
flags            0x0
magic            ........ [DON'T MATCH]
fsid            00000000-0000-0000-0000-000000000000
label
generation        0
root            0
sys_array_size        0
chunk_root_generation    0
root_level        0
chunk_root        0
chunk_root_level    0
log_root        0
log_root_transid    0
log_root_level        0
total_bytes        0
bytes_used        0
sectorsize        0
nodesize        0
leafsize (deprecated)        0
stripesize        0
root_dir        0
num_devices        0
compat_flags        0x0
compat_ro_flags        0x0
incompat_flags        0x0
cache_generation    0
uuid_tree_generation    0
dev_item.uuid        00000000-0000-0000-0000-000000000000
dev_item.fsid        00000000-0000-0000-0000-000000000000 [match]
dev_item.type        0
dev_item.total_bytes    0
dev_item.bytes_used    0
dev_item.io_align    0
dev_item.io_width    0
dev_item.sector_size    0
dev_item.devid        0
dev_item.dev_group    0
dev_item.seek_speed    0
dev_item.bandwidth    0
dev_item.generation    0
sys_chunk_array[2048]:
backup_roots[4]:

superblock: bytenr=3D67108864, device=3D/dev/sda
---------------------------------------------------------
csum_type        65178 (INVALID)
csum_size        32
csum
0x24f2057c939118ef8cf9c276a05ff294223c99ec79e0b5cfe8ed795fe0a96715
[DON'T MATCH]
bytenr            6481065229944367737
flags            0x527ffc9117fc11
            ( WRITTEN |
              CHANGING_FSID |
              METADUMP_V2 |
              unknown flag: 0x527ff09117fc10 )
magic            ...;)... [DON'T MATCH]
fsid            7011f2d5-0afe-5dc6-fce2-70e04b80939d
label
;.."`....8..8.x.?.N../....z....F..H.......|h].i.C........)........j....<?P.=
.&.......4.(.}'.)....n...9....G..D..^....g.X....g)....L..G...z.|R.V.0...K.~=
..!..~..C................pO..........@U.>....).......4....d_..5.../.......1=
.?.r....r5.E..
generation        7112314448606197494
root            10814850762639476856
sys_array_size        774240540
chunk_root_generation    17716845740647334363
root_level        123
chunk_root        9039947042838677183
chunk_root_level    7
log_root        11588818316475425470
log_root_transid    1970336570145243359
log_root_level        255
total_bytes        5626579194689281529
bytes_used        10936644453437477355
sectorsize        2711280660
nodesize        2105571139
leafsize (deprecated)        2624302184
stripesize        3748622636
root_dir        12031892002480545941
num_devices        1887426113366288834
compat_flags        0x986e28a7d6a0eedf
compat_ro_flags        0x67bf5c50764fabec
            ( unknown flag: 0x67bf5c50764fabec )
incompat_flags        0xb6351e01f2cbb867
            ( MIXED_BACKREF |
              DEFAULT_SUBVOL |
              MIXED_GROUPS |
              BIG_METADATA |
              EXTENDED_IREF |
              unknown flag: 0xb6351e01f2cbb800 )
cache_generation    16803576046500197625
uuid_tree_generation    9151978410922426283
dev_item.uuid        3eff5038-c5ed-7c44-b841-bfcaefa127ff
dev_item.fsid        ae705a3f-dcee-f7b0-9331-410c837e0ce8 [DON'T MATCH]
dev_item.type        208999962153328580
dev_item.total_bytes    4033499057947390500
dev_item.bytes_used    14123877185665736413
dev_item.io_align    356589416
dev_item.io_width    2238618352
dev_item.sector_size    33234003
dev_item.devid        4647837691355179893
dev_item.dev_group    3237710941
dev_item.seek_speed    159
dev_item.bandwidth    35
dev_item.generation    13692119449717181535
sys_chunk_array[2048]:
ERROR: sys_array_size 774240540 shouldn't exceed 2048 bytes
backup_roots[4]:
    backup 0:
        backup_tree_root:    9098106006959284508    gen:
3422959743402530751    level: 13
        backup_chunk_root:    8653729137999036921    gen:
9805354230117732311    level: 13
        backup_extent_root:    2227142819947659262    gen:
16710030944005764576    level: 250
        backup_fs_root:        17250344053212875712    gen:
11109972073411492560    level: 195
        backup_dev_root:    10813366787773230487    gen:
4733558095364468453    level: 64
        backup_csum_root:    15995327235362395775    gen:
17585993390550392957    level: 223
        backup_total_bytes:    187327539044806356
        backup_bytes_used:    11088092626626268919
        backup_num_devices:    1646767651564978160

    backup 1:
        backup_tree_root:    6132816855654833723    gen:
7933636135630997331    level: 175
        backup_chunk_root:    4500476885298477552    gen:
17588667198258184431    level: 49
        backup_extent_root:    17341284452428219997    gen:
6122825786466476477    level: 27
        backup_fs_root:        4578178975399312410    gen:
4558088662074948842    level: 229
        backup_dev_root:    17378404189136548866    gen:
8942807062595821441    level: 3
        backup_csum_root:    13954259417814538534    gen:
17582753360836298151    level: 135
        backup_total_bytes:    17760266806034071381
        backup_bytes_used:    17885472507889046480
        backup_num_devices:    11546613183057366108

    backup 2:
        backup_tree_root:    4440331691872620396    gen:
2106846041035890497    level: 65
        backup_chunk_root:    7967355651082175220    gen:
17322142655848244506    level: 255
        backup_extent_root:    8729575300770449497    gen:
4469608191637164208    level: 16
        backup_fs_root:        7343891615707958539    gen:
16087316911865450397    level: 149
        backup_dev_root:    15257776485962510925    gen:
16848351292359180192    level: 131
        backup_csum_root:    4590149763681999703    gen:
16049124123889016738    level: 65
        backup_total_bytes:    9001200061203198944
        backup_bytes_used:    16718063869519266678
        backup_num_devices:    17302961162110504123

    backup 3:
        backup_tree_root:    4736378613845015087    gen:
9295423092810071807    level: 160
        backup_chunk_root:    8495981881746054078    gen:
470622950535298717    level: 95
        backup_extent_root:    16848210704002145021    gen:
10688004551297860279    level: 126
        backup_fs_root:        383897597412126451    gen:
11250519689773919994    level: 95
        backup_dev_root:    13371050082211788147    gen:
18002259265054080238    level: 212
        backup_csum_root:    8503351800315527452    gen:
8350327863867652602    level: 227
        backup_total_bytes:    14989923284231628094
        backup_bytes_used:    4730887382996889871
        backup_num_devices:    9426020939896206591


superblock: bytenr=3D274877906944, device=3D/dev/sda
---------------------------------------------------------
csum_type        63651 (INVALID)
csum_size        32
csum
0x39db30683b693c000000004ff05c0073a1fa00db390c32963bae3c0000000037
[DON'T MATCH]
bytenr            6341162744368070656
flags            0x9731d639d900f69a
            ( RELOC |
              CHANGING_FSID |
              SEEDING |
              unknown flag: 0x9731d630d900f698 )
magic            ;.<..... [DON'T MATCH]
fsid            e25b006e-a0f9-00df-390a-32923bae3c00
label            .9~2.;.<
generation        15852938566880484858
root            17063576824041017
sys_array_size        2956094009
chunk_root_generation    9223372036858758203
root_level        0
chunk_root        2305935309654720512
chunk_root_level    212
log_root        12624074888383091845
log_root_transid    9583660007048386619
log_root_level        57
total_bytes        14916195329329095163
bytes_used        17051482582002489
sectorsize        3980091
nodesize        1526726656
leafsize (deprecated)        3573578233
stripesize        3506493855
root_dir        10664641489188945920
num_devices        10822784571284715682
compat_flags        0xe000f49ea8005ffb
compat_ro_flags        0x3cbd3b93324639
            ( FREE_SPACE_TREE |
              unknown flag: 0x3cbd3b93324638 )
incompat_flags        0x96005af986000000
            ( unknown flag: 0x96005af986000000 )
cache_generation    3554811097951074198
uuid_tree_generation    1015233417
dev_item.uuid        00000000-eabc-5e00-8fa6-f800e4395d32
dev_item.fsid        8e3bc33c-0000-0000-b5e5-490082baf100 [DON'T MATCH]
dev_item.type        4291422127885582590
dev_item.total_bytes    9622222594110062592
dev_item.bytes_used    4293392362527850751
dev_item.io_align    15507
dev_item.io_width    3404070912
dev_item.sector_size    2240479347
dev_item.devid        66834987233914
dev_item.dev_group    999109128
dev_item.seek_speed    174
dev_item.bandwidth    60
dev_item.generation    14835138647535139992
sys_chunk_array[2048]:
ERROR: sys_array_size 2956094009 shouldn't exceed 2048 bytes
backup_roots[4]:
    backup 0:
        backup_tree_root:    4596967561493494175    gen:
18423306986931093504    level: 183
        backup_chunk_root:    3637845988431400533    gen: 1069331944
 level: 242
        backup_extent_root:    5767191884994117    gen:
4594716083796982177    level: 137
        backup_fs_root:        18395560922673315840    gen:
3613920598232584041    level: 255
        backup_dev_root:    1069135421    gen: 4049836324024645    level: 6=
9
        backup_csum_root:    4590212801991227817    gen:
18441888089195413504    level: 165
        backup_total_bytes:    3734391914041082112
        backup_bytes_used:    1071101090
        backup_num_devices:    35348212198933354

    backup 1:
        backup_tree_root:    18410425735765295104    gen:
3640942247535284299    level: 26
        backup_chunk_root:    1068873171    gen: 8775799298012875    level:=
 56
        backup_extent_root:    4205280167371094039    gen:
18428472797501063168    level: 8
        backup_fs_root:        1881440420066779436    gen: 978528309
 level: 31
        backup_dev_root:    8535766461403945    gen:
4204154761370613786    level: 102
        backup_csum_root:    18440628959403048960    gen:
2208232898094253858    level: 40
        backup_total_bytes:    979511556
        backup_bytes_used:    16954280319857296
        backup_num_devices:    4207251235269916700

    backup 2:
        backup_tree_root:    2337992862355241844    gen: 980101398    level=
: 0
        backup_chunk_root:    43979460088399516    gen:
4208659288774883361    level: 0
        backup_extent_root:    18430163872154386432    gen:
2464093681987837478    level: 0
        backup_fs_root:        981019136    gen: 1550706522330047    level:=
 0
        backup_dev_root:    4214289213554047012    gen:
18420310431198347264    level: 218
        backup_csum_root:    2472256439130411120    gen: 981084532    level=
: 69
        backup_total_bytes:    13600035414614375
        backup_bytes_used:    4212037409428027428
        backup_num_devices:    18414999970424815616

    backup 3:
        backup_tree_root:    980691220    gen: 38077247303585464    level: =
230
        backup_chunk_root:    4218230876866361387    gen:
18381783371962384384    level: 156
        backup_extent_root:    2613838382487139074    gen: 982264394
 level: 58
        backup_fs_root:        14476045548981393    gen:
4147599143226259496    level: 0
        backup_dev_root:    17771694202552320    gen:
2525173747637917895    level: 186
        backup_csum_root:    965819255    gen: 20112202281518468    level: =
57
        backup_total_bytes:    4148725034551949353
        backup_bytes_used:    10188439815192576
        backup_num_devices:    2553602728877791975


> Despite that, any extra info on how this happened is also appreciated,
> as similar problem happened twice, which means we need to pay attention
> on this.

I dont know exactly what happened but here is some background:

i am running Arch Linux on mainline kernel (4.16.0-1) and mesa-git
(101352.498d9d0f4d-1) as I have a rx vega 64
over the past few months I have been getting hard locks when opening
certain programs (usually due to a bad versions of mesa-git /
llvm-git, etc).

i was at the time trying to open the program "cheese" and when I did,
my machine hard locked and only alt+shift+sysrq+b got my screen to go
black - and then did nothing else, so I held the power button for 3
seconds and then my machine rebooted.
looking at journalctl, there is a large stacktrace from kernel: amdgpu
(see attached).
then when I booted back up the pool (2 disks, 1TB + 2TB) wouldn't mount.

Thanks,
Ben

On 7 April 2018 at 09:44, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
> On 2018=E5=B9=B404=E6=9C=8807=E6=97=A5 01:03, David Sterba wrote:
>> On Fri, Apr 06, 2018 at 11:32:34PM +1000, Ben Parsons wrote:
>>> Hi,
>>>
>>> I just had an unexpected restart and now my btrfs pool wont mount.
>>> The error on mount is:
>>>
>>>     "ERROR: unsupported checksum algorithm 41700"
>>>
>>> and when running
>>>
>>>     btrfs inspect-internal dump-super /dev/sda
>>>     ERROR: bad magic on superblock on /dev/sda at 65536
>>>
>>> I saw a thread in the mailing list about it:
>>> https://www.spinics.net/lists/linux-btrfs/msg75326.html
>>> However I am told on IRC that Qu fixed it using magic.
>>>
>>> Any help would be much appreciated.
>>
>> In the previous report, there were 2 isolated areas of superblock
>> damaged. Please post output of
>>
>>       btrfs inspect dump-super /path
>
> And don't forget -Ffa option.
> -F to force btrfs-progs to recognize it as btrfs no matter what the magic=
 is
> -f shows all data so we could find all corruption and fix them if possibl=
e
> -a shows all backup superblocks, and if some backup is good, "btrfs
> rescue super-recovery" mentioned by Nikolay would be the best solution.
>
> Despite that, any extra info on how this happened is also appreciated,
> as similar problem happened twice, which means we need to pay attention
> on this.
>
> Thanks,
> Qu
>
> Thanks,
> Qu
>
>>
>> so we can see if it's a similar issue.
>>
>> In case it is, there's a tool in the btrfs-progs repo that can fix the
>> individual values.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" i=
n
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>

--f4f5e80a11d8f7ef9b0569375cee
Content-Type: text/plain; charset="US-ASCII"; name="journalctl kernel amdgpu stacktrace.txt"
Content-Disposition: attachment;
	filename="journalctl kernel amdgpu stacktrace.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_jfonble40

QXByIDA2IDIyOjI4OjMyIE1pbmktQXJjaCBrZXJuZWw6IFIxMzogMDAwMDAwMDAwMDAwMDAwZSBS
MTQ6IDAwMDA3ZmZmM2RhNTY3ODggUjE1OiAwMDAwNTYwY2Q4MGMxYjAwCkFwciAwNiAyMjoyODoz
MiBNaW5pLUFyY2gga2VybmVsOiBSMTA6IDAwMDA1NjBjZDY3MjcwMTAgUjExOiAwMDAwMDAwMDAw
MDAzMjQ2IFIxMjogMDAwMDAwMDBjMDIwNjQ0MApBcHIgMDYgMjI6Mjg6MzIgTWluaS1BcmNoIGtl
cm5lbDogUkJQOiAwMDAwN2ZmZjNkYTU2NzEwIFIwODogMDAwMDU2MGNkNzNhMGYxMCBSMDk6IDAw
MDAwMDAwMDAwMDAwMDQKQXByIDA2IDIyOjI4OjMyIE1pbmktQXJjaCBrZXJuZWw6IFJEWDogMDAw
MDdmZmYzZGE1NjcxMCBSU0k6IDAwMDAwMDAwYzAyMDY0NDAgUkRJOiAwMDAwMDAwMDAwMDAwMDBl
CkFwciAwNiAyMjoyODozMiBNaW5pLUFyY2gga2VybmVsOiBSQVg6IGZmZmZmZmZmZmZmZmZmZGEg
UkJYOiAwMDAwNTYwY2Q3M2EwZjEwIFJDWDogMDAwMDdmNjIyYTU4ZWQ4NwpBcHIgMDYgMjI6Mjg6
MzIgTWluaS1BcmNoIGtlcm5lbDogUlNQOiAwMDJiOjAwMDA3ZmZmM2RhNTY2YzggRUZMQUdTOiAw
MDAwMzI0NiBPUklHX1JBWDogMDAwMDAwMDAwMDAwMDAxMApBcHIgMDYgMjI6Mjg6MzIgTWluaS1B
cmNoIGtlcm5lbDogUklQOiAwMDMzOjB4N2Y2MjJhNThlZDg3CkFwciAwNiAyMjoyODozMiBNaW5p
LUFyY2gga2VybmVsOiAgZW50cnlfU1lTQ0FMTF82NF9hZnRlcl9od2ZyYW1lKzB4M2QvMHhhMgpB
cHIgMDYgMjI6Mjg6MzIgTWluaS1BcmNoIGtlcm5lbDogIGRvX3N5c2NhbGxfNjQrMHg3NC8weDE5
MApBcHIgMDYgMjI6Mjg6MzIgTWluaS1BcmNoIGtlcm5lbDogIFN5U19pb2N0bCsweDc0LzB4ODAK
QXByIDA2IDIyOjI4OjMyIE1pbmktQXJjaCBrZXJuZWw6ICA/IF9fc3lzX3JlY3Ztc2crMHg3ZC8w
eDkwCkFwciAwNiAyMjoyODozMiBNaW5pLUFyY2gga2VybmVsOiAgPyBfX3N5c19yZWN2bXNnKzB4
NGUvMHg5MApBcHIgMDYgMjI6Mjg6MzIgTWluaS1BcmNoIGtlcm5lbDogIGRvX3Zmc19pb2N0bCsw
eGE0LzB4NjMwCkFwciAwNiAyMjoyODozMiBNaW5pLUFyY2gga2VybmVsOiAgYW1kZ3B1X2RybV9p
b2N0bCsweDQ5LzB4ODAgW2FtZGdwdV0KQXByIDA2IDIyOjI4OjMyIE1pbmktQXJjaCBrZXJuZWw6
ICA/IHZmc193cml0ZXYrMHhiOS8weDExMApBcHIgMDYgMjI6Mjg6MzIgTWluaS1BcmNoIGtlcm5l
bDogID8gYW1kZ3B1X2dlbV9vYmplY3RfY2xvc2UrMHgxZTAvMHgxZTAgW2FtZGdwdV0KQXByIDA2
IDIyOjI4OjMyIE1pbmktQXJjaCBrZXJuZWw6ICBkcm1faW9jdGwrMHgyZDUvMHgzNzAgW2RybV0K
QXByIDA2IDIyOjI4OjMyIE1pbmktQXJjaCBrZXJuZWw6ICBkcm1faW9jdGxfa2VybmVsKzB4NWIv
MHhiMCBbZHJtXQpBcHIgMDYgMjI6Mjg6MzIgTWluaS1BcmNoIGtlcm5lbDogID8gYW1kZ3B1X2dl
bV9vYmplY3RfY2xvc2UrMHgxZTAvMHgxZTAgW2FtZGdwdV0KQXByIDA2IDIyOjI4OjMyIE1pbmkt
QXJjaCBrZXJuZWw6ICBhbWRncHVfZ2VtX2NyZWF0ZV9pb2N0bCsweDFlYy8weDI4MCBbYW1kZ3B1
XQpBcHIgMDYgMjI6Mjg6MzIgTWluaS1BcmNoIGtlcm5lbDogIGFtZGdwdV9nZW1fb2JqZWN0X2Ny
ZWF0ZSsweDdmLzB4MTEwIFthbWRncHVdCkFwciAwNiAyMjoyODozMiBNaW5pLUFyY2gga2VybmVs
OiAgPyBwcmVlbXB0X2NvdW50X2FkZCsweDY4LzB4YTAKQXByIDA2IDIyOjI4OjMyIE1pbmktQXJj
aCBrZXJuZWw6ICBhbWRncHVfYm9fY3JlYXRlKzB4NTAvMHgyMjAgW2FtZGdwdV0KQXByIDA2IDIy
OjI4OjMyIE1pbmktQXJjaCBrZXJuZWw6ICA/IGFtZGdwdV9maWxsX2J1ZmZlcisweDMwMC8weDMw
MCBbYW1kZ3B1XQpBcHIgMDYgMjI6Mjg6MzIgTWluaS1BcmNoIGtlcm5lbDogIGFtZGdwdV9ib19k
b19jcmVhdGUrMHgyMjQvMHg0YjAgW2FtZGdwdV0KQXByIDA2IDIyOjI4OjMyIE1pbmktQXJjaCBr
ZXJuZWw6ICB0dG1fYm9faW5pdF9yZXNlcnZlZCsweDM5NS8weDQ2MCBbdHRtXQpBcHIgMDYgMjI6
Mjg6MzIgTWluaS1BcmNoIGtlcm5lbDogID8gYWNwaV9vc191bm1hcF9pb21lbSsweDQyLzB4ZDAK
QXByIDA2IDIyOjI4OjMyIE1pbmktQXJjaCBrZXJuZWw6ICA/IGRybV92bWFfb2Zmc2V0X2FkZCsw
eDQxLzB4NjAgW2RybV0KQXByIDA2IDIyOjI4OjMyIE1pbmktQXJjaCBrZXJuZWw6ICB0dG1fYm9f
dmFsaWRhdGUrMHgxMjAvMHgxMzAgW3R0bV0KQXByIDA2IDIyOjI4OjMyIE1pbmktQXJjaCBrZXJu
ZWw6ICB0dG1fYm9faGFuZGxlX21vdmVfbWVtKzB4NTc3LzB4NWIwIFt0dG1dCkFwciAwNiAyMjoy
ODozMiBNaW5pLUFyY2gga2VybmVsOiAgdHRtX3R0X2JpbmQrMHgyYy8weDYwIFt0dG1dCkFwciAw
NiAyMjoyODozMiBNaW5pLUFyY2gga2VybmVsOiAgdHRtX2RtYV9wb3B1bGF0ZSsweDI1Yi8weDM1
MCBbdHRtXQpBcHIgMDYgMjI6Mjg6MzIgTWluaS1BcmNoIGtlcm5lbDogIHR0bV9kbWFfcG9vbF9n
ZXRfcGFnZXMrMHgyMTUvMHg1ZDAgW3R0bV0KQXByIDA2IDIyOjI4OjMyIE1pbmktQXJjaCBrZXJu
ZWw6ICBzd2lvdGxiX2FsbG9jX2NvaGVyZW50KzB4MWJlLzB4MWQwCkFwciAwNiAyMjoyODozMiBN
aW5pLUFyY2gga2VybmVsOiAgZHVtcF9zdGFjaysweDVjLzB4ODUKQXByIDA2IDIyOjI4OjMyIE1p
bmktQXJjaCBrZXJuZWw6IENhbGwgVHJhY2U6CkFwciAwNiAyMjoyODozMiBNaW5pLUFyY2gga2Vy
bmVsOiBIYXJkd2FyZSBuYW1lOiBNU0kgTVMtNzk3Ni9aMTcwQSBHQU1JTkcgTTcgKE1TLTc5NzYp
LCBCSU9TIDEuSTAgMDQvMjUvMjAxNwpBcHIgMDYgMjI6Mjg6MzIgTWluaS1BcmNoIGtlcm5lbDog
Q1BVOiAxIFBJRDogMzU0MyBDb21tOiBYb3JnIE5vdCB0YWludGVkIDQuMTYuMC0xLW1haW5saW5l
ICMxCkFwciAwNiAyMjoyODozMiBNaW5pLUFyY2gga2VybmVsOiBhbWRncHUgMDAwMDowMzowMC4w
OiBzd2lvdGxiOiBjb2hlcmVudCBhbGxvY2F0aW9uIGZhaWxlZCwgc2l6ZT0yMDk3MTUyCkFwciAw
NiAyMjoyODozMiBNaW5pLUFyY2gga2VybmVsOiBhbWRncHUgMDAwMDowMzowMC4wOiBzd2lvdGxi
IGJ1ZmZlciBpcyBmdWxsIChzejogMjA5NzE1MiBieXRlcykKQXByIDA2IDIyOjI4OjMyIE1pbmkt
QXJjaCBrZXJuZWw6IFIxMzogMDAwMDAwMDAwMDAwMDAwYyBSMTQ6IDAwMDA3ZmZmYTc1MWRkNzgg
UjE1OiAwMDAwNTViMDYyYjhlOGEwCkFwciAwNiAyMjoyODozMiBNaW5pLUFyY2gga2VybmVsOiBS
MTA6IDAwMDA1NWIwNDY4MTcwMTAgUjExOiAwMDAwMDAwMDAwMDAwMjQ2IFIxMjogMDAwMDAwMDBj
MDIwNjQ0MApBcHIgMDYgMjI6Mjg6MzIgTWluaS1BcmNoIGtlcm5lbDogUkJQOiAwMDAwN2ZmZmE3
NTFkZDAwIFIwODogMDAwMDU1YjA2MmI4ZTk3MCBSMDk6IDAwMDA3ZjRmZmU5OTNhYzAKQXByIDA2
IDIyOjI4OjMyIE1pbmktQXJjaCBrZXJuZWw6IFJEWDogMDAwMDdmZmZhNzUxZGQwMCBSU0k6IDAw
MDAwMDAwYzAyMDY0NDAgUkRJOiAwMDAwMDAwMDAwMDAwMDBjCkFwciAwNiAyMjoyODozMiBNaW5p
LUFyY2gga2VybmVsOiBSQVg6IGZmZmZmZmZmZmZmZmZmZGEgUkJYOiAwMDAwNTViMDYyYjhlOTcw
IFJDWDogMDAwMDdmNGZmZTZjZWQ4NwpBcHIgMDYgMjI6Mjg6MzIgTWluaS1BcmNoIGtlcm5lbDog
UlNQOiAwMDJiOjAwMDA3ZmZmYTc1MWRjYjggRUZMQUdTOiAwMDAwMDI0NiBPUklHX1JBWDogMDAw
MDAwMDAwMDAwMDAxMApBcHIgMDYgMjI6Mjg6MzIgTWluaS1BcmNoIGtlcm5lbDogUklQOiAwMDMz
OjB4N2Y0ZmZlNmNlZDg3CkFwciAwNiAyMjoyODozMiBNaW5pLUFyY2gga2VybmVsOiAgZW50cnlf
U1lTQ0FMTF82NF9hZnRlcl9od2ZyYW1lKzB4M2QvMHhhMgpBcHIgMDYgMjI6Mjg6MzIgTWluaS1B
cmNoIGtlcm5lbDogIGRvX3N5c2NhbGxfNjQrMHg3NC8weDE5MApBcHIgMDYgMjI6Mjg6MzIgTWlu
aS1BcmNoIGtlcm5lbDogIFN5U19pb2N0bCsweDc0LzB4ODAKQXByIDA2IDIyOjI4OjMyIE1pbmkt
QXJjaCBrZXJuZWw6ICA/IF9fZG9fcGFnZV9mYXVsdCsweDMxNy8weDVhMApBcHIgMDYgMjI6Mjg6
MzIgTWluaS1BcmNoIGtlcm5lbDogIGRvX3Zmc19pb2N0bCsweGE0LzB4NjMwCkFwciAwNiAyMjoy
ODozMiBNaW5pLUFyY2gga2VybmVsOiAgYW1kZ3B1X2RybV9pb2N0bCsweDQ5LzB4ODAgW2FtZGdw
dV0KQXByIDA2IDIyOjI4OjMyIE1pbmktQXJjaCBrZXJuZWw6ICA/IF9faGFuZGxlX21tX2ZhdWx0
KzB4YmZmLzB4MTRkMApBcHIgMDYgMjI6Mjg6MzIgTWluaS1BcmNoIGtlcm5lbDogID8gYW1kZ3B1
X2dlbV9vYmplY3RfY2xvc2UrMHgxZTAvMHgxZTAgW2FtZGdwdV0KQXByIDA2IDIyOjI4OjMyIE1p
bmktQXJjaCBrZXJuZWw6ICBkcm1faW9jdGwrMHgyZDUvMHgzNzAgW2RybV0KQXByIDA2IDIyOjI4
OjMyIE1pbmktQXJjaCBrZXJuZWw6ICBkcm1faW9jdGxfa2VybmVsKzB4NWIvMHhiMCBbZHJtXQpB
cHIgMDYgMjI6Mjg6MzIgTWluaS1BcmNoIGtlcm5lbDogID8gYW1kZ3B1X2dlbV9vYmplY3RfY2xv
c2UrMHgxZTAvMHgxZTAgW2FtZGdwdV0KQXByIDA2IDIyOjI4OjMyIE1pbmktQXJjaCBrZXJuZWw6
ICBhbWRncHVfZ2VtX2NyZWF0ZV9pb2N0bCsweDFlYy8weDI4MCBbYW1kZ3B1XQpBcHIgMDYgMjI6
Mjg6MzIgTWluaS1BcmNoIGtlcm5lbDogIGFtZGdwdV9nZW1fb2JqZWN0X2NyZWF0ZSsweDdmLzB4
MTEwIFthbWRncHVdCkFwciAwNiAyMjoyODozMiBNaW5pLUFyY2gga2VybmVsOiAgPyB0dG1fZXVf
YmFja29mZl9yZXNlcnZhdGlvbisweDRkLzB4NzAgW3R0bV0KQXByIDA2IDIyOjI4OjMyIE1pbmkt
QXJjaCBrZXJuZWw6ICBhbWRncHVfYm9fY3JlYXRlKzB4NTAvMHgyMjAgW2FtZGdwdV0KQXByIDA2
IDIyOjI4OjMyIE1pbmktQXJjaCBrZXJuZWw6ICA/IGFtZGdwdV9maWxsX2J1ZmZlcisweDMwMC8w
eDMwMCBbYW1kZ3B1XQpBcHIgMDYgMjI6Mjg6MzIgTWluaS1BcmNoIGtlcm5lbDogIGFtZGdwdV9i
b19kb19jcmVhdGUrMHgyMjQvMHg0YjAgW2FtZGdwdV0KQXByIDA2IDIyOjI4OjMyIE1pbmktQXJj
aCBrZXJuZWw6ICB0dG1fYm9faW5pdF9yZXNlcnZlZCsweDM5NS8weDQ2MCBbdHRtXQpBcHIgMDYg
MjI6Mjg6MzIgTWluaS1BcmNoIGtlcm5lbDogID8gYWNwaV9vc191bm1hcF9pb21lbSsweDQyLzB4
ZDAKQXByIDA2IDIyOjI4OjMyIE1pbmktQXJjaCBrZXJuZWw6ICA/IGRybV92bWFfb2Zmc2V0X2Fk
ZCsweDQxLzB4NjAgW2RybV0KQXByIDA2IDIyOjI4OjMyIE1pbmktQXJjaCBrZXJuZWw6ICB0dG1f
Ym9fdmFsaWRhdGUrMHgxMjAvMHgxMzAgW3R0bV0KQXByIDA2IDIyOjI4OjMyIE1pbmktQXJjaCBr
ZXJuZWw6ICB0dG1fYm9faGFuZGxlX21vdmVfbWVtKzB4NTc3LzB4NWIwIFt0dG1dCkFwciAwNiAy
MjoyODozMiBNaW5pLUFyY2gga2VybmVsOiAgdHRtX3R0X2JpbmQrMHgyYy8weDYwIFt0dG1dCkFw
ciAwNiAyMjoyODozMiBNaW5pLUFyY2gga2VybmVsOiAgdHRtX2RtYV9wb3B1bGF0ZSsweDI1Yi8w
eDM1MCBbdHRtXQpBcHIgMDYgMjI6Mjg6MzIgTWluaS1BcmNoIGtlcm5lbDogIHR0bV9kbWFfcG9v
bF9nZXRfcGFnZXMrMHgyMTUvMHg1ZDAgW3R0bV0KQXByIDA2IDIyOjI4OjMyIE1pbmktQXJjaCBr
ZXJuZWw6ICBzd2lvdGxiX2FsbG9jX2NvaGVyZW50KzB4MWJlLzB4MWQwCkFwciAwNiAyMjoyODoz
MiBNaW5pLUFyY2gga2VybmVsOiAgZHVtcF9zdGFjaysweDVjLzB4ODUKQXByIDA2IDIyOjI4OjMy
IE1pbmktQXJjaCBrZXJuZWw6IENhbGwgVHJhY2U6CkFwciAwNiAyMjoyODozMiBNaW5pLUFyY2gg
a2VybmVsOiBIYXJkd2FyZSBuYW1lOiBNU0kgTVMtNzk3Ni9aMTcwQSBHQU1JTkcgTTcgKE1TLTc5
NzYpLCBCSU9TIDEuSTAgMDQvMjUvMjAxNwpBcHIgMDYgMjI6Mjg6MzIgTWluaS1BcmNoIGtlcm5l
bDogQ1BVOiAxIFBJRDogMzY4NyBDb21tOiBnbm9tZS1zaGVsbCBOb3QgdGFpbnRlZCA0LjE2LjAt
MS1tYWlubGluZSAjMQpBcHIgMDYgMjI6Mjg6MzIgTWluaS1BcmNoIGtlcm5lbDogYW1kZ3B1IDAw
MDA6MDM6MDAuMDogc3dpb3RsYjogY29oZXJlbnQgYWxsb2NhdGlvbiBmYWlsZWQsIHNpemU9MjA5
NzE1MgpBcHIgMDYgMjI6Mjg6MzIgTWluaS1BcmNoIGtlcm5lbDogYW1kZ3B1IDAwMDA6MDM6MDAu
MDogc3dpb3RsYiBidWZmZXIgaXMgZnVsbCAoc3o6IDIwOTcxNTIgYnl0ZXMpCg==
--f4f5e80a11d8f7ef9b0569375cee--
