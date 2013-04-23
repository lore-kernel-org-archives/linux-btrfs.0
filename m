Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:63690 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756391Ab3DWQSk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Apr 2013 12:18:40 -0400
Received: by mail-ob0-f169.google.com with SMTP id tb18so679616obb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Apr 2013 09:18:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130423150302.GB16552@liubo.jp.oracle.com>
References: <CAKuK5J3NgU-V5XH_vZFTLZpisZL-OQ7Kn0Riis-VghB0YfLaYg@mail.gmail.com>
 <CAKuK5J3eRzHmRbfgBYuo38AYAC8=BKyB5knSUeXsC=_gfFr-pA@mail.gmail.com>
 <CAKuK5J0VUeJfyC66PWzbqwEdkKksMtVhYwd+5irsoP3Gz9V9dA@mail.gmail.com>
 <CAKuK5J1ECpg0VM9s01F2Jknsw7OTEDAbEFKNUNFYGZyfcTX=NQ@mail.gmail.com> <20130423150302.GB16552@liubo.jp.oracle.com>
From: Jon Nelson <jnelson@jamponi.net>
Date: Tue, 23 Apr 2013 11:18:19 -0500
Message-ID: <CAKuK5J28WtOvx--YvJEeVd8ND+GPiFrL8GCr3aUjpC+n2fz3Cg@mail.gmail.com>
Subject: Re: corrupted filesystem. mounts with -o recovery,ro but not -o
 recovery or -o ro
To: bo.li.liu@oracle.com
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 23, 2013 at 10:03 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
>
> Can you please show us where it BUG_ON(or logs) when mounting with "-o recovery"?
> (the stack info below seems not to be a resulf of '-o recovery'?)

I have this from 3.8.8:

2013-04-19T21:19:47.060937-05:00 turnip kernel: [  100.608815] device
fsid 7feedf1e-9711-4900-af9c-92738ea8aace devid 5 transid 246530
/dev/sdd
2013-04-19T21:19:47.072892-05:00 turnip kernel: [  100.619694] btrfs:
enabling auto recovery
2013-04-19T21:19:47.072925-05:00 turnip kernel: [  100.619700] btrfs:
disk space caching is enabled
2013-04-19T21:19:55.156935-05:00 turnip kernel: [  108.692720] btrfs:
csum mismatch on free space cache
2013-04-19T21:19:55.156978-05:00 turnip kernel: [  108.692745] btrfs:
failed to load free space cache for block group 2618814627840
2013-04-19T21:19:55.156982-05:00 turnip kernel: [  108.693108] btrfs:
csum mismatch on free space cache
2013-04-19T21:19:55.156985-05:00 turnip kernel: [  108.693133] btrfs:
failed to load free space cache for block group 2619888369664
2013-04-19T21:19:57.924956-05:00 turnip kernel: [  111.453762] btrfs:
csum mismatch on free space cache
2013-04-19T21:19:57.924999-05:00 turnip kernel: [  111.453784] btrfs:
failed to load free space cache for block group 2620962111488
2013-04-19T21:19:58.139783-05:00 turnip kernel: [  111.521418] leaf
2618819321856 total ptrs 25 free space 1780
2013-04-19T21:19:58.139814-05:00 turnip kernel: [  111.521428]
item 0 key (2621340270592 a8 4096) itemoff 3908 itemsize 87
2013-04-19T21:19:58.139817-05:00 turnip kernel: [  111.521434]
extent refs 5 gen 214210 flags 2
2013-04-19T21:19:58.139822-05:00 turnip kernel: [  111.521439]
tree block key (562484 1 0) level 0
2013-04-19T21:19:58.139864-05:00 turnip kernel: [  111.521441]
tree block backref root 5
2013-04-19T21:19:58.139873-05:00 turnip kernel: [  111.521445]
shared block backref parent 2621774995456
2013-04-19T21:19:58.139875-05:00 turnip kernel: [  111.521448]
shared block backref parent 2621603078144
2013-04-19T21:19:58.139877-05:00 turnip kernel: [  111.521451]
shared block backref parent 2621340147712
2013-04-19T21:19:58.139879-05:00 turnip kernel: [  111.521453]
shared block backref parent 2621312724992
2013-04-19T21:19:58.139880-05:00 turnip kernel: [  111.521458]
item 1 key (2621340274688 a8 4096) itemoff 3857 itemsize 51
2013-04-19T21:19:58.139882-05:00 turnip kernel: [  111.521462]
extent refs 1 gen 214217 flags 258
2013-04-19T21:19:58.139884-05:00 turnip kernel: [  111.521466]
tree block key (159644 54 627062569) level 0
2013-04-19T21:19:58.139885-05:00 turnip kernel: [  111.521469]
shared block backref parent 2621340254208
2013-04-19T21:19:58.139887-05:00 turnip kernel: [  111.521473]
item 2 key (2621340286976 a8 4096) itemoff 3761 itemsize 96
2013-04-19T21:19:58.139888-05:00 turnip kernel: [  111.521476]
extent refs 6 gen 214207 flags 2
2013-04-19T21:19:58.139890-05:00 turnip kernel: [  111.521480]
tree block key (562122 c 469151) level 0
2013-04-19T21:19:58.139891-05:00 turnip kernel: [  111.521482]
tree block backref root 5
2013-04-19T21:19:58.139892-05:00 turnip kernel: [  111.521485]
shared block backref parent 2622020726784
2013-04-19T21:19:58.139894-05:00 turnip kernel: [  111.521488]
shared block backref parent 2621647806464
2013-04-19T21:19:58.139895-05:00 turnip kernel: [  111.521491]
shared block backref parent 2621520723968
2013-04-19T21:19:58.139897-05:00 turnip kernel: [  111.521494]
shared block backref parent 2621378756608
2013-04-19T21:19:58.139898-05:00 turnip kernel: [  111.521496]
shared block backref parent 2621341069312
2013-04-19T21:19:58.139900-05:00 turnip kernel: [  111.521501]
item 3 key (2621340295168 a8 4096) itemoff 3710 itemsize 51
2013-04-19T21:19:58.139901-05:00 turnip kernel: [  111.521505]
extent refs 1 gen 241434 flags 2
2013-04-19T21:19:58.139903-05:00 turnip kernel: [  111.521509]
tree block key (2620335087616 b6 2621224001536) level 0
2013-04-19T21:19:58.139904-05:00 turnip kernel: [  111.521516]
tree block backref root 2
2013-04-19T21:19:58.139906-05:00 turnip kernel: [  111.521521]
item 4 key (2621340299264 a8 4096) itemoff 3659 itemsize 51
2013-04-19T21:19:58.139907-05:00 turnip kernel: [  111.521525]
extent refs 1 gen 208634 flags 258
2013-04-19T21:19:58.139909-05:00 turnip kernel: [  111.521529]
tree block key (11446 1 0) level 1
2013-04-19T21:19:58.139910-05:00 turnip kernel: [  111.521531]
shared block backref parent 2621405974528
2013-04-19T21:19:58.139912-05:00 turnip kernel: [  111.521541]
item 5 key (2621340303360 a8 4096) itemoff 3608 itemsize 51
2013-04-19T21:19:58.139913-05:00 turnip kernel: [  111.521544]
extent refs 1 gen 208634 flags 258
2013-04-19T21:19:58.139915-05:00 turnip kernel: [  111.521548]
tree block key (11547 6c 0) level 0
2013-04-19T21:19:58.139917-05:00 turnip kernel: [  111.521550]
shared block backref parent 2621340299264
2013-04-19T21:19:58.139918-05:00 turnip kernel: [  111.521555]
item 6 key (2621340307456 a8 4096) itemoff 3557 itemsize 51
2013-04-19T21:19:58.139921-05:00 turnip kernel: [  111.521558]
extent refs 1 gen 208634 flags 258
2013-04-19T21:19:58.139922-05:00 turnip kernel: [  111.521562]
tree block key (11544 c 11203) level 0
2013-04-19T21:19:58.139923-05:00 turnip kernel: [  111.521564]
shared block backref parent 2621340299264
2013-04-19T21:19:58.139925-05:00 turnip kernel: [  111.521569]
item 7 key (2621340311552 a8 4096) itemoff 3506 itemsize 51
2013-04-19T21:19:58.139927-05:00 turnip kernel: [  111.521572]
extent refs 1 gen 208634 flags 258
2013-04-19T21:19:58.139928-05:00 turnip kernel: [  111.521575]
tree block key (11549 c 444261) level 0
2013-04-19T21:19:58.139929-05:00 turnip kernel: [  111.521578]
shared block backref parent 2621340299264
2013-04-19T21:19:58.139931-05:00 turnip kernel: [  111.521582]
item 8 key (2621340315648 a8 4096) itemoff 3428 itemsize 78
2013-04-19T21:19:58.139932-05:00 turnip kernel: [  111.521586]
extent refs 4 gen 214207 flags 2
2013-04-19T21:19:58.139934-05:00 turnip kernel: [  111.521589]
tree block key (562348 1 0) level 0
2013-04-19T21:19:58.139935-05:00 turnip kernel: [  111.521592]
tree block backref root 5
2013-04-19T21:19:58.139936-05:00 turnip kernel: [  111.521596]
shared block backref parent 2621360304128
2013-04-19T21:19:58.139938-05:00 turnip kernel: [  111.521599]
shared block backref parent 2621341069312
2013-04-19T21:19:58.139939-05:00 turnip kernel: [  111.521602]
shared block backref parent 2621274116096
2013-04-19T21:19:58.139940-05:00 turnip kernel: [  111.521606]
item 9 key (2621340319744 a8 4096) itemoff 3350 itemsize 78
2013-04-19T21:19:58.139942-05:00 turnip kernel: [  111.521610]
extent refs 4 gen 214207 flags 2
2013-04-19T21:19:58.139944-05:00 turnip kernel: [  111.521613]
tree block key (562346 6c 0) level 0
2013-04-19T21:19:58.139945-05:00 turnip kernel: [  111.521615]
tree block backref root 5
2013-04-19T21:19:58.139946-05:00 turnip kernel: [  111.521618]
shared block backref parent 2621360304128
2013-04-19T21:19:58.139948-05:00 turnip kernel: [  111.521621]
shared block backref parent 2621341069312
2013-04-19T21:19:58.139949-05:00 turnip kernel: [  111.521623]
shared block backref parent 2621274116096
2013-04-19T21:19:58.139950-05:00 turnip kernel: [  111.521628]
item 10 key (2621340327936 a8 4096) itemoff 3299 itemsize 51
2013-04-19T21:19:58.139952-05:00 turnip kernel: [  111.521631]
extent refs 1 gen 245184 flags 258
2013-04-19T21:19:58.139954-05:00 turnip kernel: [  111.521634]
tree block key (595897 c 469182) level 0
2013-04-19T21:19:58.139956-05:00 turnip kernel: [  111.521642]
tree block backref root 2691
2013-04-19T21:19:58.139958-05:00 turnip kernel: [  111.521646]
item 11 key (2621340332032 a8 4096) itemoff 3212 itemsize 87
2013-04-19T21:19:58.139959-05:00 turnip kernel: [  111.521649]
extent refs 5 gen 214216 flags 2
2013-04-19T21:19:58.139961-05:00 turnip kernel: [  111.521653]
tree block key (562521 6c 0) level 0
2013-04-19T21:19:58.139962-05:00 turnip kernel: [  111.521655]
tree block backref root 5
2013-04-19T21:19:58.139963-05:00 turnip kernel: [  111.521658]
shared block backref parent 2621774995456
2013-04-19T21:19:58.139965-05:00 turnip kernel: [  111.521661]
shared block backref parent 2621603078144
2013-04-19T21:19:58.139966-05:00 turnip kernel: [  111.521664]
shared block backref parent 2621340147712
2013-04-19T21:19:58.139968-05:00 turnip kernel: [  111.521666]
shared block backref parent 2621312724992
2013-04-19T21:19:58.139969-05:00 turnip kernel: [  111.521670]
item 12 key (2621340336128 a8 4096) itemoff 3125 itemsize 87
2013-04-19T21:19:58.139970-05:00 turnip kernel: [  111.521675]
extent refs 5 gen 214213 flags 2
2013-04-19T21:19:58.139972-05:00 turnip kernel: [  111.521679]
tree block key (562502 1 0) level 0
2013-04-19T21:19:58.139973-05:00 turnip kernel: [  111.521681]
tree block backref root 5
2013-04-19T21:19:58.139975-05:00 turnip kernel: [  111.521684]
shared block backref parent 2621774995456
2013-04-19T21:19:58.139976-05:00 turnip kernel: [  111.521686]
shared block backref parent 2621603078144
2013-04-19T21:19:58.139977-05:00 turnip kernel: [  111.521689]
shared block backref parent 2621340147712
2013-04-19T21:19:58.139979-05:00 turnip kernel: [  111.521692]
shared block backref parent 2621312724992
2013-04-19T21:19:58.139981-05:00 turnip kernel: [  111.521696]
item 13 key (2621340340224 a8 4096) itemoff 3038 itemsize 87
2013-04-19T21:19:58.139983-05:00 turnip kernel: [  111.521699]
extent refs 5 gen 214213 flags 2
2013-04-19T21:19:58.139985-05:00 turnip kernel: [  111.521703]
tree block key (562498 c 469153) level 0
2013-04-19T21:19:58.139986-05:00 turnip kernel: [  111.521705]
tree block backref root 5
2013-04-19T21:19:58.139987-05:00 turnip kernel: [  111.521708]
shared block backref parent 2621774995456
2013-04-19T21:19:58.139989-05:00 turnip kernel: [  111.521711]
shared block backref parent 2621603078144
2013-04-19T21:19:58.139990-05:00 turnip kernel: [  111.521714]
shared block backref parent 2621340147712
2013-04-19T21:19:58.139992-05:00 turnip kernel: [  111.521716]
shared block backref parent 2621312724992
2013-04-19T21:19:58.139993-05:00 turnip kernel: [  111.521721]
item 14 key (2621340348416 a8 4096) itemoff 2987 itemsize 51
2013-04-19T21:19:58.139995-05:00 turnip kernel: [  111.521724]
extent refs 1 gen 195080 flags 258
2013-04-19T21:19:58.139996-05:00 turnip kernel: [  111.521727]
tree block key (127757 6c 1826816) level 0
2013-04-19T21:19:58.139997-05:00 turnip kernel: [  111.521730]
shared block backref parent 2621367582720
2013-04-19T21:19:58.139999-05:00 turnip kernel: [  111.521734]
item 15 key (2621340352512 a8 4096) itemoff 2900 itemsize 87
2013-04-19T21:19:58.140001-05:00 turnip kernel: [  111.521738]
extent refs 5 gen 214214 flags 2
2013-04-19T21:19:58.140002-05:00 turnip kernel: [  111.521741]
tree block key (562517 1 0) level 0
2013-04-19T21:19:58.140004-05:00 turnip kernel: [  111.521744]
tree block backref root 5
2013-04-19T21:19:58.140005-05:00 turnip kernel: [  111.521746]
shared block backref parent 2621774995456
2013-04-19T21:19:58.140007-05:00 turnip kernel: [  111.521749]
shared block backref parent 2621603078144
2013-04-19T21:19:58.140008-05:00 turnip kernel: [  111.521752]
shared block backref parent 2621340147712
2013-04-19T21:19:58.140010-05:00 turnip kernel: [  111.521754]
shared block backref parent 2621312724992
2013-04-19T21:19:58.140011-05:00 turnip kernel: [  111.521759]
item 16 key (2621340356608 a8 4096) itemoff 2813 itemsize 87
2013-04-19T21:19:58.140012-05:00 turnip kernel: [  111.521762]
extent refs 5 gen 214213 flags 2
2013-04-19T21:19:58.140014-05:00 turnip kernel: [  111.521765]
tree block key (562501 1 0) level 0
2013-04-19T21:19:58.140015-05:00 turnip kernel: [  111.521768]
tree block backref root 5
2013-04-19T21:19:58.140017-05:00 turnip kernel: [  111.521771]
shared block backref parent 2621774995456
2013-04-19T21:19:58.140018-05:00 turnip kernel: [  111.521773]
shared block backref parent 2621603078144
2013-04-19T21:19:58.140019-05:00 turnip kernel: [  111.521776]
shared block backref parent 2621340147712
2013-04-19T21:19:58.140021-05:00 turnip kernel: [  111.521779]
shared block backref parent 2621312724992
2013-04-19T21:19:58.140022-05:00 turnip kernel: [  111.521783]
item 17 key (2621340360704 a8 4096) itemoff 2762 itemsize 51
2013-04-19T21:19:58.140024-05:00 turnip kernel: [  111.521786]
extent refs 1 gen 208634 flags 258
2013-04-19T21:19:58.140025-05:00 turnip kernel: [  111.521790]
tree block key (554179 1 0) level 0
2013-04-19T21:19:58.140027-05:00 turnip kernel: [  111.521792]
shared block backref parent 2621406539776
2013-04-19T21:19:58.140028-05:00 turnip kernel: [  111.521797]
item 18 key (2621340364800 a8 4096) itemoff 2711 itemsize 51
2013-04-19T21:19:58.140029-05:00 turnip kernel: [  111.521800]
extent refs 1 gen 208634 flags 258
2013-04-19T21:19:58.140032-05:00 turnip kernel: [  111.521803]
tree block key (552007 6c 0) level 1
2013-04-19T21:19:58.140034-05:00 turnip kernel: [  111.521806]
tree block backref root 2399
2013-04-19T21:19:58.140072-05:00 turnip kernel: [  111.521810]
item 19 key (2621340368896 a8 4096) itemoff 2660 itemsize 51
2013-04-19T21:19:58.140075-05:00 turnip kernel: [  111.521814]
extent refs 1 gen 208634 flags 258
2013-04-19T21:19:58.140077-05:00 turnip kernel: [  111.521817]
tree block key (552155 1 0) level 0
2013-04-19T21:19:58.140078-05:00 turnip kernel: [  111.521820]
shared block backref parent 2621340364800
2013-04-19T21:19:58.140080-05:00 turnip kernel: [  111.521824]
item 20 key (2621340372992 a8 4096) itemoff 2609 itemsize 51
2013-04-19T21:19:58.140082-05:00 turnip kernel: [  111.521827]
extent refs 1 gen 229374 flags 2
2013-04-19T21:19:58.140083-05:00 turnip kernel: [  111.521831]
tree block key (2620440666112 a8 4096) level 0
2013-04-19T21:19:58.140085-05:00 turnip kernel: [  111.521833]
tree block backref root 2
2013-04-19T21:19:58.140086-05:00 turnip kernel: [  111.521837]
item 21 key (2621340377088 a8 4096) itemoff 2558 itemsize 51
2013-04-19T21:19:58.140087-05:00 turnip kernel: [  111.521841]
extent refs 1 gen 208634 flags 258
2013-04-19T21:19:58.140089-05:00 turnip kernel: [  111.521844]
tree block key (552212 1 0) level 1
2013-04-19T21:19:58.140090-05:00 turnip kernel: [  111.521847]
tree block backref root 2399
2013-04-19T21:19:58.140092-05:00 turnip kernel: [  111.521851]
item 22 key (2621340381184 a8 4096) itemoff 2507 itemsize 51
2013-04-19T21:19:58.140093-05:00 turnip kernel: [  111.521854]
extent refs 1 gen 208634 flags 258
2013-04-19T21:19:58.140095-05:00 turnip kernel: [  111.521858]
tree block key (552288 1 0) level 0
2013-04-19T21:19:58.140097-05:00 turnip kernel: [  111.521860]
shared block backref parent 2621340377088
2013-04-19T21:19:58.140098-05:00 turnip kernel: [  111.521865]
item 23 key (2621340393472 a8 4096) itemoff 2456 itemsize 51
2013-04-19T21:19:58.140099-05:00 turnip kernel: [  111.521868]
extent refs 1 gen 245867 flags 258
2013-04-19T21:19:58.140101-05:00 turnip kernel: [  111.521872]
tree block key (367314 6c 0) level 1
2013-04-19T21:19:58.140178-05:00 turnip kernel: [  111.521874]
tree block backref root 2693
2013-04-19T21:19:58.140180-05:00 turnip kernel: [  111.521878]
item 24 key (2621340397568 a8 4096) itemoff 2405 itemsize 51
2013-04-19T21:19:58.140182-05:00 turnip kernel: [  111.521887]
extent refs 1 gen 245867 flags 258
2013-04-19T21:19:58.140183-05:00 turnip kernel: [  111.521890]
tree block key (367342 c 370588) level 0
2013-04-19T21:19:58.140184-05:00 turnip kernel: [  111.521894]
shared block backref parent 2621340393472
2013-04-19T21:19:58.140186-05:00 turnip kernel: [  111.521897]
------------[ cut here ]------------
2013-04-19T21:19:58.140187-05:00 turnip kernel: [  111.521956]
WARNING: at /home/abuild/rpmbuild/BUILD/kernel-default-3.8.8/linux-3.8/fs/btrfs/extent-tree.c:5208
__btrfs_free_extent+0x853/0x890 [btrfs]()
2013-04-19T21:19:58.140189-05:00 turnip kernel: [  111.521960]
Hardware name: TA790GX XE
2013-04-19T21:19:58.140191-05:00 turnip kernel: [  111.521964] Modules
linked in: md5 xt_REDIRECT xt_pkttype xt_physdev xt_TCPMSS xt_tcpudp
xt_LOG xt_limit iptable_nat nf_nat_ipv4 nf_nat iptable_mangle xt_mark
ebt_ip ebtable_filter ebtables nfsd nfs_acl auth_rpcgss nfs fscache
lockd sunrpc bridge stp llc ip6t_REJECT nf_conntrack_ipv6
nf_defrag_ipv6 ip6table_raw ipt_REJECT iptable_raw xt_CT
iptable_filter ip6table_mangle nf_conntrack_ftp
nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv4
nf_defrag_ipv4 ip_tables xt_conntrack nf_conntrack ip6table_filter
ip6_tables x_tables cpufreq_conservative cpufreq_userspace
cpufreq_powersave snd_hda_codec_hdmi snd_hda_codec_realtek
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer btrfs radeon
ttm zlib_deflate snd libcrc32c drm_kms_helper sp5100_tco drm soundcore
acpi_cpufreq raid1 edac_core snd_page_alloc sr_mod cdrom edac_mce_amd
sg mperf pcspkr k10temp i2c_algo_bit i2c_piix4 ata_generic
via_velocity r8169 pata_atiixp kvm_amd ehci_pci kvm microcode
button shpchp pci_hotplug wmi crc_ccitt tcp_htcp autofs4 ohci_hcd
ehci_hcd usbcore usb_common scsi_dh_hp_sw scsi_dh_emc scsi_dh_alua
scsi_dh_rdac scsi_dh dm_mirror dm_region_hash dm_log dm_mod edd fan
thermal processor thermal_sys
2013-04-19T21:19:58.140194-05:00 turnip kernel: [  111.522094] Pid:
3654, comm: btrfs-transacti Not tainted 3.8.8-1-default #1
2013-04-19T21:19:58.140195-05:00 turnip kernel: [  111.522098] Call Trace:
2013-04-19T21:19:58.140196-05:00 turnip kernel: [  111.522126]
[<ffffffff81004658>] dump_trace+0x78/0x2b0
2013-04-19T21:19:58.140198-05:00 turnip kernel: [  111.522140]
[<ffffffff81559259>] dump_stack+0x69/0x6f
2013-04-19T21:19:58.140200-05:00 turnip kernel: [  111.522153]
[<ffffffff81043c29>] warn_slowpath_common+0x79/0xc0
2013-04-19T21:19:58.140201-05:00 turnip kernel: [  111.522191]
[<ffffffffa0423973>] __btrfs_free_extent+0x853/0x890 [btrfs]
2013-04-19T21:19:58.140203-05:00 turnip kernel: [  111.522287]
[<ffffffffa04273cf>] run_clustered_refs+0x45f/0xaf0 [btrfs]
2013-04-19T21:19:58.140204-05:00 turnip kernel: [  111.522382]
[<ffffffffa042b1ba>] btrfs_run_delayed_refs+0xca/0x310 [btrfs]
2013-04-19T21:19:58.140207-05:00 turnip kernel: [  111.522486]
[<ffffffffa043a7b0>] btrfs_commit_transaction+0x80/0xa70 [btrfs]
2013-04-19T21:19:58.140208-05:00 turnip kernel: [  111.522608]
[<ffffffffa0433bb5>] transaction_kthread+0x195/0x210 [btrfs]
2013-04-19T21:19:58.140209-05:00 turnip kernel: [  111.522705]
[<ffffffff81066063>] kthread+0xb3/0xc0
2013-04-19T21:19:58.140211-05:00 turnip kernel: [  111.522717]
[<ffffffff8156c43c>] ret_from_fork+0x7c/0xb0
2013-04-19T21:19:58.140212-05:00 turnip kernel: [  111.522727] ---[
end trace 26eb4d92d8121420 ]---
2013-04-19T21:19:58.140213-05:00 turnip kernel: [  111.522732] btrfs
unable to find ref byte nr 2621340344320 parent 0 root 2  owner 1
offset 0
2013-04-19T21:19:58.140215-05:00 turnip kernel: [  111.522736]
------------[ cut here ]------------
2013-04-19T21:19:58.140216-05:00 turnip kernel: [  111.522762]
WARNING: at /home/abuild/rpmbuild/BUILD/kernel-default-3.8.8/linux-3.8/fs/btrfs/extent-tree.c:5265
__btrfs_free_extent+0x7ba/0x890 [btrfs]()
2013-04-19T21:19:58.140218-05:00 turnip kernel: [  111.522765]
Hardware name: TA790GX XE
2013-04-19T21:19:58.140220-05:00 turnip kernel: [  111.522767] Modules
linked in: md5 xt_REDIRECT xt_pkttype xt_physdev xt_TCPMSS xt_tcpudp
xt_LOG xt_limit iptable_nat nf_nat_ipv4 nf_nat iptable_mangle xt_mark
ebt_ip ebtable_filter ebtables nfsd nfs_acl auth_rpcgss nfs fscache
lockd sunrpc bridge stp llc ip6t_REJECT nf_conntrack_ipv6
nf_defrag_ipv6 ip6table_raw ipt_REJECT iptable_raw xt_CT
iptable_filter ip6table_mangle nf_conntrack_ftp
nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv4
nf_defrag_ipv4 ip_tables xt_conntrack nf_conntrack ip6table_filter
ip6_tables x_tables cpufreq_conservative cpufreq_userspace
cpufreq_powersave snd_hda_codec_hdmi snd_hda_codec_realtek
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer btrfs radeon
ttm zlib_deflate snd libcrc32c drm_kms_helper sp5100_tco drm soundcore
acpi_cpufreq raid1 edac_core snd_page_alloc sr_mod cdrom edac_mce_amd
sg mperf pcspkr k10temp i2c_algo_bit i2c_piix4 ata_generic
via_velocity r8169 pata_atiixp kvm_amd ehci_pci kvm microcode
button shpchp pci_hotplug wmi crc_ccitt tcp_htcp autofs4 ohci_hcd
ehci_hcd usbcore usb_common scsi_dh_hp_sw scsi_dh_emc scsi_dh_alua
scsi_dh_rdac scsi_dh dm_mirror dm_region_hash dm_log dm_mod edd fan
thermal processor thermal_sys
2013-04-19T21:19:58.140222-05:00 turnip kernel: [  111.522903] Pid:
3654, comm: btrfs-transacti Tainted: G        W    3.8.8-1-default #1
2013-04-19T21:19:58.140223-05:00 turnip kernel: [  111.522906] Call Trace:
2013-04-19T21:19:58.140225-05:00 turnip kernel: [  111.522917]
[<ffffffff81004658>] dump_trace+0x78/0x2b0
2013-04-19T21:19:58.140226-05:00 turnip kernel: [  111.522926]
[<ffffffff81559259>] dump_stack+0x69/0x6f
2013-04-19T21:19:58.140227-05:00 turnip kernel: [  111.522936]
[<ffffffff81043c29>] warn_slowpath_common+0x79/0xc0
2013-04-19T21:19:58.140229-05:00 turnip kernel: [  111.522975]
[<ffffffffa04238da>] __btrfs_free_extent+0x7ba/0x890 [btrfs]
2013-04-19T21:19:58.140230-05:00 turnip kernel: [  111.523053]
[<ffffffffa04273cf>] run_clustered_refs+0x45f/0xaf0 [btrfs]
2013-04-19T21:19:58.140231-05:00 turnip kernel: [  111.523141]
[<ffffffffa042b1ba>] btrfs_run_delayed_refs+0xca/0x310 [btrfs]
2013-04-19T21:19:58.140233-05:00 turnip kernel: [  111.523238]
[<ffffffffa043a7b0>] btrfs_commit_transaction+0x80/0xa70 [btrfs]
2013-04-19T21:19:58.140234-05:00 turnip kernel: [  111.523364]
[<ffffffffa0433bb5>] transaction_kthread+0x195/0x210 [btrfs]
2013-04-19T21:19:58.140235-05:00 turnip kernel: [  111.523449]
[<ffffffff81066063>] kthread+0xb3/0xc0
2013-04-19T21:19:58.140236-05:00 turnip kernel: [  111.523459]
[<ffffffff8156c43c>] ret_from_fork+0x7c/0xb0
2013-04-19T21:19:58.140238-05:00 turnip kernel: [  111.523472] ---[
end trace 26eb4d92d8121421 ]---
2013-04-19T21:19:58.140239-05:00 turnip kernel: [  111.523485] btrfs:
run_one_delayed_ref returned -2
2013-04-19T21:19:58.140240-05:00 turnip kernel: [  111.523489]
------------[ cut here ]------------
2013-04-19T21:19:58.140241-05:00 turnip kernel: [  111.523520]
WARNING: at /home/abuild/rpmbuild/BUILD/kernel-default-3.8.8/linux-3.8/fs/btrfs/super.c:256
__btrfs_abort_transaction+0xc3/0xe0 [btrfs]()
2013-04-19T21:19:58.140244-05:00 turnip kernel: [  111.523523]
Hardware name: TA790GX XE
2013-04-19T21:19:58.140245-05:00 turnip kernel: [  111.523526] btrfs:
Transaction aborted
2013-04-19T21:19:58.140246-05:00 turnip kernel: [  111.523528] Modules
linked in: md5 xt_REDIRECT xt_pkttype xt_physdev xt_TCPMSS xt_tcpudp
xt_LOG xt_limit iptable_nat nf_nat_ipv4 nf_nat iptable_mangle xt_mark
ebt_ip ebtable_filter ebtables nfsd nfs_acl auth_rpcgss nfs fscache
lockd sunrpc bridge stp llc ip6t_REJECT nf_conntrack_ipv6
nf_defrag_ipv6 ip6table_raw ipt_REJECT iptable_raw xt_CT
iptable_filter ip6table_mangle nf_conntrack_ftp
nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv4
nf_defrag_ipv4 ip_tables xt_conntrack nf_conntrack ip6table_filter
ip6_tables x_tables cpufreq_conservative cpufreq_userspace
cpufreq_powersave snd_hda_codec_hdmi snd_hda_codec_realtek
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer btrfs radeon
ttm zlib_deflate snd libcrc32c drm_kms_helper sp5100_tco drm soundcore
acpi_cpufreq raid1 edac_core snd_page_alloc sr_mod cdrom edac_mce_amd
sg mperf pcspkr k10temp i2c_algo_bit i2c_piix4 ata_generic
via_velocity r8169 pata_atiixp kvm_amd ehci_pci kvm microcode
button shpchp pci_hotplug wmi crc_ccitt tcp_htcp autofs4 ohci_hcd
ehci_hcd usbcore usb_common scsi_dh_hp_sw scsi_dh_emc scsi_dh_alua
scsi_dh_rdac scsi_dh dm_mirror dm_region_hash dm_log dm_mod edd fan
thermal processor thermal_sys
2013-04-19T21:19:58.140249-05:00 turnip kernel: [  111.523651] Pid:
3654, comm: btrfs-transacti Tainted: G        W    3.8.8-1-default #1
2013-04-19T21:19:58.140250-05:00 turnip kernel: [  111.523654] Call Trace:
2013-04-19T21:19:58.140252-05:00 turnip kernel: [  111.523665]
[<ffffffff81004658>] dump_trace+0x78/0x2b0
2013-04-19T21:19:58.140253-05:00 turnip kernel: [  111.523674]
[<ffffffff81559259>] dump_stack+0x69/0x6f
2013-04-19T21:19:58.140254-05:00 turnip kernel: [  111.523683]
[<ffffffff81043c29>] warn_slowpath_common+0x79/0xc0
2013-04-19T21:19:58.140255-05:00 turnip kernel: [  111.523702]
[<ffffffff81043d25>] warn_slowpath_fmt+0x45/0x50
2013-04-19T21:19:58.140256-05:00 turnip kernel: [  111.523730]
[<ffffffffa0412323>] __btrfs_abort_transaction+0xc3/0xe0 [btrfs]
2013-04-19T21:19:58.140258-05:00 turnip kernel: [  111.523781]
[<ffffffffa042b338>] btrfs_run_delayed_refs+0x248/0x310 [btrfs]
2013-04-19T21:19:58.140259-05:00 turnip kernel: [  111.523877]
[<ffffffffa043a7b0>] btrfs_commit_transaction+0x80/0xa70 [btrfs]
2013-04-19T21:19:58.140261-05:00 turnip kernel: [  111.523995]
[<ffffffffa0433bb5>] transaction_kthread+0x195/0x210 [btrfs]
2013-04-19T21:19:58.140263-05:00 turnip kernel: [  111.524085]
[<ffffffff81066063>] kthread+0xb3/0xc0
2013-04-19T21:19:58.140264-05:00 turnip kernel: [  111.524101]
[<ffffffff8156c43c>] ret_from_fork+0x7c/0xb0
2013-04-19T21:19:58.140265-05:00 turnip kernel: [  111.524108] ---[
end trace 26eb4d92d8121422 ]---
2013-04-19T21:19:58.140267-05:00 turnip kernel: [  111.524120] BTRFS
error (device sdd) in btrfs_run_delayed_refs:2504: error 2
2013-04-19T21:19:58.140268-05:00 turnip kernel: [  111.524124] BTRFS
warning (device sdd): Skipping commit of aborted transaction.
2013-04-19T21:19:58.140269-05:00 turnip kernel: [  111.524129] BTRFS
error (device sdd) in cleanup_transaction:1391: error 2
2013-04-19T21:19:58.140271-05:00 turnip kernel: [  111.524180] BUG:
unable to handle kernel paging request at ffffffff81066158
2013-04-19T21:19:58.140272-05:00 turnip kernel: [  111.524330] IP:
[<ffffffff81564735>] _raw_spin_lock+0x5/0x30
2013-04-19T21:19:58.140273-05:00 turnip kernel: [  111.524446] PGD
1a0f067 PUD 1a13063 PMD 10001e1
2013-04-19T21:19:58.140275-05:00 turnip kernel: [  111.524560] Oops:
0003 [#1] SMP
2013-04-19T21:19:58.140307-05:00 turnip kernel: [  111.524641] Modules
linked in: md5 xt_REDIRECT xt_pkttype xt_physdev xt_TCPMSS xt_tcpudp
xt_LOG xt_limit iptable_nat nf_nat_ipv4 nf_nat iptable_mangle xt_mark
ebt_ip ebtable_filter ebtables nfsd nfs_acl auth_rpcgss nfs fscache
lockd sunrpc bridge stp llc ip6t_REJECT nf_conntrack_ipv6
nf_defrag_ipv6 ip6table_raw ipt_REJECT iptable_raw xt_CT
iptable_filter ip6table_mangle nf_conntrack_ftp
nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv4
nf_defrag_ipv4 ip_tables xt_conntrack nf_conntrack ip6table_filter
ip6_tables x_tables cpufreq_conservative cpufreq_userspace
cpufreq_powersave snd_hda_codec_hdmi snd_hda_codec_realtek
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer btrfs radeon
ttm zlib_deflate snd libcrc32c drm_kms_helper sp5100_tco drm soundcore
acpi_cpufreq raid1 edac_core snd_page_alloc sr_mod cdrom edac_mce_amd
sg mperf pcspkr k10temp i2c_algo_bit i2c_piix4 ata_generic
via_velocity r8169 pata_atiixp kvm_amd ehci_pci kvm microcode
button shpchp pci_hotplug wmi crc_ccitt tcp_htcp autofs4 ohci_hcd
ehci_hcd usbcore usb_common scsi_dh_hp_sw scsi_dh_emc scsi_dh_alua
scsi_dh_rdac scsi_dh dm_mirror dm_region_hash dm_log dm_mod edd fan
thermal processor thermal_sys
2013-04-19T21:19:58.140309-05:00 turnip kernel: [  111.527399] CPU 2
2013-04-19T21:19:58.140310-05:00 turnip kernel: [  111.527445] Pid:
3654, comm: btrfs-transacti Tainted: G        W    3.8.8-1-default #1
BIOSTAR Group TA790GX XE/TA790GX XE
2013-04-19T21:19:58.140311-05:00 turnip kernel: [  111.527653] RIP:
0010:[<ffffffff81564735>]  [<ffffffff81564735>]
_raw_spin_lock+0x5/0x30
2013-04-19T21:19:58.140313-05:00 turnip kernel: [  111.527814] RSP:
0018:ffff88009269bd90  EFLAGS: 00010292
2013-04-19T21:19:58.140314-05:00 turnip kernel: [  111.527919] RAX:
0000000000010000 RBX: ffffffff81066140 RCX: 0000000000000206
2013-04-19T21:19:58.140315-05:00 turnip kernel: [  111.528054] RDX:
0000000000000000 RSI: ffffffff81066140 RDI: ffffffff81066158
2013-04-19T21:19:58.140316-05:00 turnip kernel: [  111.533266] RBP:
0000000000000206 R08: 0000000000000000 R09: ffff880095fd8f41
2013-04-19T21:19:58.140317-05:00 turnip kernel: [  111.538452] R10:
0000000000000000 R11: 000000000000045b R12: 0000000000000000
2013-04-19T21:19:58.140319-05:00 turnip kernel: [  111.543576] R13:
5355544155415641 R14: ffffffff81065fb0 R15: 0000000000001d4c
2013-04-19T21:19:58.140320-05:00 turnip kernel: [  111.548695] FS:
00007ff197f32800(0000) GS:ffff88009dc80000(0000)
knlGS:0000000000000000
2013-04-19T21:19:58.140321-05:00 turnip kernel: [  111.553823] CS:
0010 DS: 0000 ES: 0000 CR0: 000000008005003b
2013-04-19T21:19:58.140323-05:00 turnip kernel: [  111.558971] CR2:
ffffffff81066158 CR3: 000000007f10b000 CR4: 00000000000007e0
2013-04-19T21:19:58.140324-05:00 turnip kernel: [  111.564109] DR0:
0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
2013-04-19T21:19:58.140325-05:00 turnip kernel: [  111.569244] DR3:
0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
2013-04-19T21:19:58.140326-05:00 turnip kernel: [  111.574337] Process
btrfs-transacti (pid: 3654, threadinfo ffff88009269a000, task
ffff880092698040)
2013-04-19T21:19:58.140328-05:00 turnip kernel: [  111.579538] Stack:
2013-04-19T21:19:58.140329-05:00 turnip kernel: [  111.584689]
ffffffffa04224a5 ffff88009269bd98 ffff88009269bd98 00000000fffffffe
2013-04-19T21:19:58.140331-05:00 turnip kernel: [  111.590020]
ffff880096926e70 000000005171fb4d ffffffffa0436a3b 00000000fffffffe
2013-04-19T21:19:58.140332-05:00 turnip kernel: [  111.595382]
ffff880097f4f000 ffff880096925e40 ffffffffa043a878 0000000000000000
2013-04-19T21:19:58.140333-05:00 turnip kernel: [  111.600722] Call Trace:
2013-04-19T21:19:58.140335-05:00 turnip kernel: [  111.605988]
[<ffffffffa04224a5>] block_rsv_release_bytes+0x35/0x180 [btrfs]
2013-04-19T21:19:58.140336-05:00 turnip kernel: [  111.611386]
[<ffffffffa0436a3b>] btrfs_cleanup_one_transaction+0x2b/0xf0 [btrfs]
2013-04-19T21:19:58.140349-05:00 turnip kernel: [  111.616829]
[<ffffffffa043a878>] btrfs_commit_transaction+0x148/0xa70 [btrfs]
2013-04-19T21:19:58.140351-05:00 turnip kernel: [  111.622291]
[<ffffffffa0433bb5>] transaction_kthread+0x195/0x210 [btrfs]
2013-04-19T21:19:58.140352-05:00 turnip kernel: [  111.627654]
[<ffffffff81066063>] kthread+0xb3/0xc0
2013-04-19T21:19:58.140353-05:00 turnip kernel: [  111.632904]
[<ffffffff8156c43c>] ret_from_fork+0x7c/0xb0
2013-04-19T21:19:58.140355-05:00 turnip kernel: [  111.638120] Code:
e9 a1 fe ff ff 90 48 c7 c2 ff ff ff ff be 01 00 00 00 e9 8f fe ff ff
90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 b8 00 00 01 00 <f0> 0f c1
07 89 c2 c1 ea 10 66 39 c2 74 0f 0f 1f 44 00 00 f3 90
2013-04-19T21:19:58.140356-05:00 turnip kernel: [  111.649605] RIP
[<ffffffff81564735>] _raw_spin_lock+0x5/0x30
2013-04-19T21:19:58.140359-05:00 turnip kernel: [  111.655188]  RSP
<ffff88009269bd90>
2013-04-19T21:19:58.140363-05:00 turnip kernel: [  111.660707] CR2:
ffffffff81066158
2013-04-19T21:19:58.140364-05:00 turnip kernel: [  111.666163] ---[
end trace 26eb4d92d8121423 ]---



--
Jon
Software Blacksmith
