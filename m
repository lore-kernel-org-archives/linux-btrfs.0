Return-Path: <SRS0=hUT/=SD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51B12C43381
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 05:53:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03D1E20850
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 05:53:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="H4NR9MFe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbfDAFxW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Apr 2019 01:53:22 -0400
Received: from mout.gmx.net ([212.227.17.22]:36775 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725860AbfDAFxW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 Apr 2019 01:53:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554097970;
        bh=l5cd78NKPWKoUtxDh9Ah3upYeBj6eR3rD3H62q+U2Og=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=H4NR9MFeWuWYPe3wO/mkTm97rqoHJcC3lRQ+M7SFgI8UjE5SqKB2yf1HYaSXtM+QT
         3dzw4NTNyj/sYRzCif9Ius2F/sNN35BBsMLdE4pjLZ0eN7ktTRvZ+xufnry9G6cx0i
         socn2mtJ0IHBYQZ55eCvgqEfM9HYlr1o7X1FYoQw=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0Meduu-1hZ83N3TjM-00OHTd; Mon, 01
 Apr 2019 07:52:50 +0200
Subject: Re: [PATCH 7/7] btrfs: tests/fsck: Add test image for free space
 cache mode repair
To:     Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190325082253.19583-1-wqu@suse.com>
 <20190325082253.19583-8-wqu@suse.com>
 <1e65e3ab-dc48-db4b-3035-85ba2786d909@suse.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0IlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT6JAVQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVuQENBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAGJATwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <e0478f6d-1d43-90f9-7e9a-9142ba89060a@gmx.com>
Date:   Mon, 1 Apr 2019 13:52:45 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <1e65e3ab-dc48-db4b-3035-85ba2786d909@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:w4MGvSyheJ7+TEMB2oY7465j/rG89s2i1g30b7Q93hjPbXrX414
 mN38hggAc42U5Zla9A2u0WWd4NAJifO8sAiuS8Szlu5yydQcgmQnir85xxxW3dvDE4Ic7ZQ
 Sy2nDsRZXPU9IaJseo3YWY47abOoWJBzmOokQeb9cjRz3t39pxVxGEBu68GNT7NTjEdshAB
 abOcLRWZG/3ZUF8py7lZw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:lsOXn7i4mbU=:9zEv2fLwtkyQwtET0eCzRi
 qWqDlZYYjwHUDYvJlM5YJGWNZoNg+xrq9LvMKru8Vlg1gKAAEj0qH+oNP3ZEoI5MZY+NSsoXJ
 7vMrnoVNHjiE6C4TJXtcophCvGAgrs2GLFK/kuHOGNc5qPxxp+W63HwW5REiLtSzd1v1qeH1h
 0RHtcLtz3wj3Mn8neoqi/T+ajPa4yt/BTpTTonMsp31C8fnuw+uSjUqNJdZ8lb0ri4xul5KWn
 DKZzU6hOakH91IwaXSRfFwtYcDh2ljhsySe+NsO0GmJlqh3v+j0Mz2piFTzKmdZ3wkpO2fvn5
 2j+a1S32Q3yi4DMdly5tKtvRqHy/+fYRMm1M88gG7NJDKUJcAlNKgYzv/pasJPNfjWAw6/ElO
 cue0j39yirvzL0hBSN4yljXcMCPJjiELyMe1KCmtVD2wIV0AWnTEW1aW3oskXAPjYjTrxFrvh
 jnu/hqo245cv+4bC6eTAZO9FF1uxUM7GprxErRsZOHalSWpdlWsw8lrzDg5DNwPPUSfnZ0VPG
 ZOcxAjfxWP9S20awERCuyYeGH4tQyhmq2m/nmYaaUCpJw9HC7y47OSPfen7n83H/vXvpStqid
 MFQCxZhXRVSllESd4fJqGBg5DIxZgWwlvTeUH+5uWWKz9E/Yy5isBeUl9gmfH84mlcu/QIPPD
 BoZsyI6Gxkm9wqhDGO6WJZYMm/rbFC1iDe7XwsVqXt24DlabUpohWtnbXvGQ+1nRIbowJ4Yk7
 FMiDNZNbVXzoVdXqd1uxm30SMWzrvWVuhf5xpIyQGYD6YrRAax3nISp7pryqM38K/fB47yepX
 ej3+3/STcixUhzi6t/4bn4TB4tbvgGkLxW6BTxOU16HIU3taQMtHrjdSPl5IDfujIUifpjWTW
 gxASqyfsTdzCYAkGWUc5zS7nHypTmt15LWEZExab5gfmfxxOv2zebnBmsWFoPDPgRuBi4li12
 MNH1Ewmn84w==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/3/29 =E4=B8=8B=E5=8D=888:05, Nikolay Borisov wrote:
>
>
> On 25.03.19 =D0=B3. 10:22 =D1=87., Qu Wenruo wrote:
>> The image has one free space cache inode with invalid mode (0).
>>         item 9 key (256 INODE_ITEM 0) itemoff 13702 itemsize 160
>>                 generation 30 transid 30 size 65536 nbytes 1507328
>>                 block group 0 mode 0 links 1 uid 0 gid 0 rdev 0
>>                 sequence 23 flags 0x1b(NODATASUM|NODATACOW|NOCOMPRESS|P=
REALLOC)
>>                 atime 0.0 (1970-01-01 08:00:00)
>>                 ctime 1553491158.189771625 (2019-03-25 13:19:18)
>>                 mtime 0.0 (1970-01-01 08:00:00)
>>                 otime 0.0 (1970-01-01 08:00:00)
>>
>> Both lowmem and original mode should be able to detect and fix it.
>>
>> The extracted test image is pretty big (1G extracted), as kernel won't
>> cache small chunks.
>> Even with SSD, such test may still take some seconds just extracting th=
e
>> image.
>
>
> Should this image contain also a non-freespace but root inode (for the
> root dir case) so it has full coverage of the code you introduced?

In fact the only possible repair is for free space cache.
ROOT_TREE_DIR repair is just a common base, and there is no entry for it.

Thanks,
Qu

>
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  .../test.raw.xz                                | Bin 0 -> 159128 bytes
>>  1 file changed, 0 insertions(+), 0 deletions(-)
>>  create mode 100644 tests/fsck-tests/038-bad-free-space-cache-inode-mod=
e/test.raw.xz
>>
>> diff --git a/tests/fsck-tests/038-bad-free-space-cache-inode-mode/test.=
raw.xz b/tests/fsck-tests/038-bad-free-space-cache-inode-mode/test.raw.xz
>> new file mode 100644
>> index 0000000000000000000000000000000000000000..c2603c024098992bece235d=
27187eefa696b3fe0
>> GIT binary patch
>> literal 159128
>> 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
)
>> zK_CVu@j6a$SNrq1(|O8fN#0@?(N1rhUM{G#zN*rYboklpoKqWvDL+N;-Id0A&^cx7
>> zIcuqIZ^46<wB(NSS81&+x?S7u&es}D*IeA~d90k<%)D+V(_?R0(Xwq4b@%xv+!)?_
>> zl@J`x9TJ(T5%KruFE4+n*&ORr#PhCHG`!;sgH)c-6PBE$l*7yqF0}d`AkE^5I6tEP
>> zakqPD;-TxB`2)kdJ?l4^nHiC`W>A}(M2Ilycy_NKvk!EPp^pr!$s*tJt1t~aA;iId
>> z`R9y+4Ntea6ur_BRg+=3Dgn=3DxOk`Ydg@?8Lfl%H1z7HA=3DJbI#Tl99o#54+!EwOr7~F=
I
>> zctBBsYOp^!lR9yWZffah3`hRwp-_SuF)GJAB=3D=3D5UZ)np{m6wq35V3N5U`B6>=3D0Mp=
C
>> z2Ev}iH>;lb(_Up^YH{B`-0!+0eqGDUm23w(@=3DdlU@W_)0^}Suk)XCDzy|X=3Do@@~La
>> z)UTgm-EVium3i<B_yzm|e)$>qj|2Dsd_N2DVF~_Mzea#o1zHu~r&WP>DZcW75PXvO
>> zB=3DJdNiVIU*nBu||7pAx{#f2%ZAO5@?>>b!Uuy?Rl?(eZy4hA9&#HD)w74{D79oRdt
>> zcVO?p-hsUXdk6Lo>>b!UdP^m@f8fS#D19h>D19h>D19h>D19h>D19h>D19jXGRi2m
>> zsQKqvZI|gQ_<tau{J{SjXaqC@8Uc-fMnEH=3D5zq)|^dr&e4ypSeU(Av{X8n`bFs;#a
>> zN`;sFvSdn%xxKL)*hMF(1Pcmiv)qpMIngOSH5QhC`G&m9E_UXG^{nC1gS#9wV-j6@
>> zZNkr-xXL5(@mwO=3Dv}@pk1m{}iyKPpYr?ztiN_M{!s&b!9rZ)_c2sF(ypxytKSG#^&
>> zadS%F_x<N~9Ev~lBb;oY%p5eWe9W8GG<&g!C+hwCtn;<qHy6V6^DDex*+|ROM^YX#
>> z;!WKkLS;SSaO}|)vrm4)GUi3?p6MU@XvDNGla1LBSnj00lhRRBS$-@if{xBHQj+Y%
>> zPRqT^OlPDN7lx(GsfJQ4J+!8jM`wyZGp{=3D+Q6qTe8FPi%YYoYFLh+#=3DSL<4oCfzmL
>> zA#OWPcJXkR{szBQ>S1iEYb{f#>q;)2S+#oEvfS2Rja4L%B-KZcnJ?TX`QJ-}G%wmF
>> z_G#xAYI)8C8tBhxdwKa^9i6gGF4~=3DN;!xIGvMhCx;fzNO_kEi?S|5MDc<!l@HFIX4
>> z$rBgnYdc+^1RW(9MJHBUUw9fTKz%_@h^0K~`VNvh=3DO!sJ4r?!^jilvqw~RBqiZg=3Df
>> zGD+V=3DwJ>e7c$n^OZ@pS=3DN8B^Zh-)M1k~2NJ@(QNU&p*A!cBaTZ<Wu<k1_cWByW{aU
>> zLuu}bI_R)^F5I7`mzpvUY1h74P_xY0kmw|QZ|rCf|FSr@_2tB!v#CmwxnXt>I$A>l
>> zD2XzcwYZkO&Z-@vVO?=3D;I5{l-nyKf>j2CNci6Nm|oqWiH*laYeH3>iGN@@)Kpr$y&
>> zzC(Pp<<;SmC`bJmvzXo0S?5=3Dn$h?Ylp!AVr-b&bdX+~C{O8-Xds?;^a$>!_hiqTEx
>> ztD=3DcCgPl(6?fjj2lSHUnw=3Dj%Fm$;{qyYp^&@K7?`Q<TP?)HA_rk~OY<d9S=3D^vEkP=
F
>> z6|$P)g`A-xIv#p4yG070Hplqgs#Ueh()Kc9o75etx1k)96o}Gxaq|y3S8%l=3D!S%GM
>> zu(npglV@TM+nd*1$Yw|ovD~iKUwlV#+m|SUT$dM>ph`?&9A|(<v*9hrSn^(<kqL?k
>> z_T<47dpWL_*<%C)VQL4*nQQ)667@ICDeL{xL|3t&$2rmUoMm*zZsrx|?o6$4(QfZ#
>> z*xlSu{47=3D$T-MONw&OtdyNji5{z7>TR4V=3D4gQvqUh<UCqcKF12HF1D4+e6Rt7~wuK
>> zFZ+GJ0W*P*>qX?+mmNOubE!D2FWfLV&+Dy`X|r~ixa!<qRw)AYvP3Q=3Dt<A4J__K$Y
>> zds^9BB@=3D5m&ii*#2^6oJE?;lx8l5oHTd&U46Ir6ixo=3DK|%}Zr9WvX}X3%}9V@}pHY
>> zua7l8RIE+QDW5U7Z&P*_6l3)Ju<d=3DN)!RI;5h1$4SiiwHS2!!H8uh}(sI6-cH}X7~
>> zbgeZ$`6=3Dq)ahG?S3UW^ks<x9@U%MsEsxcX!>{D?zNn4v)s`_l$9tMVn{5DB@8b^x;
>> z-A2OErxHxcQk;7^`<Q&4l^;3GNtQl0EviuHOiuR_m^YkK(baQSV=3D5obq3<~HV8Byv
>> zD*J7xgzmb$4s&Ayci8Uy6H5E0YxT<v8*lrbOw{B`cx$wmJL2>HU)A4gy$Yk$Ssk}0
>> z?p5>aeV-1F`#A`2?tZLsFm&BjO0px>HZm+_5|U9#t4NcEZc+=3D5q%Rn3$grhl4NEDN
>> zy0reKO<W4!k&%tHK1~r(0p|rnCj}g4RxgQ*(fC*`0$Xmd<px`Bu;m6@ZfKiA8PhXO
>> zaOYyl&z%?fGUJPMWPe-Bf0y41?)f5rD+CMyL%RX(2DBS~a;vT@bB?G5Gx$fE!MOX1
>> zyRS<%j1L_K9R?i+9R?i+9fq+FjD0}qL+N889ux6P(o2S?pCiC-w6t;?O^`(b9Rh}c
>> z;gejt0U{KA6#b<gQA36y!;oQRmwf)U4j7*PA{7k+hJY=3Dt1Vn}*!;oQUv!Ts~HXGV(
>> zXtSZshBh18Y-qEg&BhNj0vZ90fJQ*0za1LIlXm`@1uH-2mK!7S;Ij)K_Od!p?@=3D+n
>> zBA|LA?5J?mV2S!+;)vo-QlHHegq|z52{(H6WJ&U9?FDTD>SF`_KNLOodC^fk*InJ-
>> zB$620;koW<B*~$~^&Fcf+r=3DrL`;k1m{$zr_=3D)>c(6Ir=3DaeDCIu3vX6ek|v9p9_M&=
J
>> z;-uSFk}%m|{fN_$nnaiF(cZJ+sVvIe>VZd88n#$T*fEzncZJ;&l2%)_$^YHL7vXp3
>> zN;emnc*pfiP8+%DbUQ}$ahKjO)ZXg0Z%*Tztf5f(<rzPgMqp_KmPTM{1eQi%X~g$h
>> zR)k3qOoCt%1d|}tG9G{IVQ839Fr#2b!Hj|#^|v#luw`SBTQ=3DxPCH{Kuor5St7rpgn
>> zscSbR2?mT3;vDgX!QX6P!@eu*F>Eo|Vz9+vi@_FyEe2bRKJ7nQ0}KuZ2ZR6TcY%xQ
>> zi~KGSFa&IA3kfm|8HNnQ?g($sGV_XmO)|%m*8lZvF~?{f#*}r^GH1e1d*93SVyZI^
>> zsT=3D3l<lO2=3Dn|zc};b_5tf6cDVUJ8@HL=3Dz<#d&Ai{a+h6t#UC_gt2HR|NyqjB_eAp=
W
>> zOoWZ~Y?D;eo|!aJ4vDDDofhV<-sc9U+^6P_J&sKZPo|(07bqOMqiecTZsOvm)1P&_
>> zMpg`}xVf=3Diu#C13D&)Fp#Two-NUU<YSE*voZ>5u^M3W&Jyers%??lUuZkK%#1Rkqv
>> zp<#iau1+P^X~=3DCfaeK%~%jxif(XA&vyGo%_BTItsY0q+vA!fP40gqz7)LF{F&T02{
>> zI!=3DXiPPe^Tc&(b+Tt3RP{QD8KO6`|>;n=3D~kgJTEB4vrlhJ2-Z5><rib>FEGioQvc}
>> z1PlRNTF^#@A;XYi=3DsNuAvmKuBA`1xuhJY<?<wb@e!;oQU)BMji4aU6}Iqr>sAz*lg
>> zQdH;Pw<{qlAS)m%AS)m%1W*5g%?of`7g;_LFa&IA&l_YIG7K4pCJ34!Sby-%ZoNBZ
>> z=3D)ZnrNU{8LRafR5QR^G6z6X3S@~A?<5U`~^+mT_&Fk~3~F!*8c!-}6R{U%bl6^lG?
>> z5HJL6X%A>*7%~hQ1_KcWA`C<rh<NAp8=3D1Y36_6E>6_6E>6_6E>6_6E>6?i@!&!^-0
>> zbUdGq=3DhMf5MnEH=3D5zq)|1T+E~0gZr0KqH_L&<JP*G%^Aj0gZr0KqH_L&<JP*Gy)m{
>> zjetf#BcKt`=3Dr`UT#ues8c2f~B1Z-(N7GxMQ3>k*40@x~mtpeC8@Ov&EPDz}SI3;mP
>> z;*`WGiBl4%<TvVdK~_LkKvqCjKvqCjKvqCjKvw*i5gO<)=3DrHIo=3DrHIo=3DrHIo=3Dr=
HIo
>> z=3DrA{Nj`+f0Tx|HgYJjDYi`2{r7y`Dmkbw+Ch9SdnBNsPvaU&PP6~gr!VJu_?WCdge
>> zWCdgeWCdgeWCdi!k8#JL!=3DS^U!=3DS^U!=3DS^U!=3DS^U!=3DS^ka19IBuy73v*RXI6=
3)ir4
>> zZ7t9UXaqC@8Uc-fMnEH=3D5zq)|1T+E~0gZr0)<7em5zq)|1T+E~0gZr0KqH_L&<JP*
>> zGy)o7(MLVd2xtT}0vZ90fJQ(gpb^jrXaqC@8Uc-fMp{54pb^jrXaqC@8Uc-fMnEH=3D
>> z5zq)|1T+E~Z3h|wjetf#BcKt`2xtT}0vZ90fJQ(gpb^k09cTnJ0vZ90fJQ(gpb^jr
>> zXaqC@8Uc-fMnEGipb^jrXaqC@8Uc-fMnEH=3D5zq)|1T+E~0gYAzjetf#BcKt`2xtT}
>> z0vZ90fJQ(gpb^jrXjB0-0vZ90fJQ(gpb^jrXaqC@8Uc-fMnEH=3DkqpoXXaqC@8Uc-f
>> zMnEH=3D5zq)|1T+E~0gZr0>_8)+5zq)|1T+E~0gZr0KqH_L&<JP*Gy)pY1C4-2KqH_L
>> z&<JP*Gy)m{jetf#BcRduKqJpC4-!_A5j*Xa`O-UX;vDgX|E<Hs1AHV%{_$7TAo-m1
>> iabF_|=3D~x%F$3OnaNk~d>QI@f=3D$!sS3=3DRY9VH~24oN>cy;
>>
>> literal 0
>> HcmV?d00001
>>
