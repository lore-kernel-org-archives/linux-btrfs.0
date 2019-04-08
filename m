Return-Path: <SRS0=zp8L=SK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCACAC282CE
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 08:06:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7787020883
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 08:06:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="L3OJw2Ts"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725983AbfDHIGs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Apr 2019 04:06:48 -0400
Received: from mout.gmx.net ([212.227.17.20]:55755 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725877AbfDHIGs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Apr 2019 04:06:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554710803;
        bh=aww5zEEimOUz4+yurf8nFjh2eyHqYqeGAGDKNV4kkCE=;
        h=X-UI-Sender-Class:To:From:Subject:Date;
        b=L3OJw2TsQX+jHIr6RKN3jtlphceqDuOAvx8gogjtfRiDDKiavl/yMNaRJAq5c+2D/
         lcyCMatyrjAlSkM5aAqpLm3gIwvEc8JzEEdr/JTJrSOQcKEHeiT5OCAJAJCjxonmaS
         CceiFhX/5HQ52XYYbSsNTxFOkD9V67VPxasPiH8M=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MIPhr-1hBUpJ16fH-0049Ga for
 <linux-btrfs@vger.kernel.org>; Mon, 08 Apr 2019 10:06:43 +0200
To:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Btrfs tree locker performance analyser v2
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
Message-ID: <de699f91-11a6-6ce1-31ec-acabcaa814a8@gmx.com>
Date:   Mon, 8 Apr 2019 16:06:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="wa7X5cckpP9kyNIscjGKu9wGQQsrHr2EW"
X-Provags-ID: V03:K1:Q4zm/AwAwfStKokq8cwnW3xjzynSm9VTIRXpqGN42gXTSZTkfpb
 YmWpYcBZendf1ffxT7EwRCZFAygXBbHXPKEsRAyGJ6MqrEe0CZPFFrlw2I1w75YbyN/k982
 mhELSFf/uEVMy4jYOIYGTXioQyfA2N+IPgIuNAZ6IbPMyY0YiBa2jCgrVrQK05zqIqNphmM
 +Fo1R7H4VjZESD5XsOAZQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:UqxiwQId2aQ=:jnILb+H2sWRjc2MbbN/VkY
 4da8F30ZxayjYyBe+V7hFQncGC73pQq2CwqFGE3EYLZREL1FP85NRMGzQ1Y3jgY9SkYiJ2SGg
 xt1qT69xDL2b/uZ8V38By9MzYT70mRM5eptVXNbIfHT77b/mmbbMW2cZ8u2jG9n9Z84bWDidu
 fwvW+ycQ5o0mJsud1ot/oOEXz5TA+p7gNrFeuqDzRyJQmhh+jlR0hnwTZZ91vuBwE05UnS/KP
 bSgzXkQl4dmtWyA+sTBrPlh03osBqIGNHBOp9WxhNouJ4XzEyoIfTS+VwUvAHguOzq8Wfcyuf
 UoSy5z/DGzrk9H2wYrOMzMYbVQwDfkCl0wMrs3MlgSZZHsRLXQdUHUMfDq4RS4ERhT2w8rhrP
 aRUNjibjyCbC6OeyBnJpmIkP873G3n2VXbewGTh2FsjAgQMMcP/3S+1FtcIdx7uS0nWmKgOuJ
 UchepbJcyxWgZgF95s4hmBKBc2R2Gfm5xIjg8D0B2KnN4eO85yaHUBn9pAxLZmgx2iLkGmR3C
 cJdqbq2bq+CuZuIbBnMjfea4GcRib/Jhyqq4E71L1zhNWzGGi/YEoFaOiC8oeza+OXND+pZNH
 7jbqI/XR1kDgYC5lKD5qoC5hJ5yV+15QLfHMjuE6XeUtHXJBwPwmSPdCHYueXWOATQU/dt2nA
 ota7naW6HOioN9421LATpRtl/GMlRn/QwTjmwbOT8E+xigyPj+eDzq+0HeqV2ph4WlY8veskv
 eoWwRNs0KA6Y0tM//PLuVhD2kkqriW4ccxCbkrKalxtsnHa6yzJAQIzwnbp06jdcX01t419wK
 ryVPQhiefB/CvCG0vRbKI3sSaAcrncLlanI1iZ/dgTwA/MjLA8LKrG3fomnGjrc7pGUMbXGTp
 r2Qutnt7+Sl+WVm+1TnCx9k977EekIXJ6apHZo1jCu5ZfiXQYbOvGXUlflm371
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wa7X5cckpP9kyNIscjGKu9wGQQsrHr2EW
Content-Type: multipart/mixed; boundary="wd2ohWURGFRLy8GbciPuxQGZccDPV0zba";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <de699f91-11a6-6ce1-31ec-acabcaa814a8@gmx.com>
Subject: Btrfs tree locker performance analyser v2

--wd2ohWURGFRLy8GbciPuxQGZccDPV0zba
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi,

There is the second version of btrfs tree locker analyser.
https://gist.github.com/adam900710/766767dba5381b86534c9051780ed262

The script is also attached to the end of mail.

Please note that, it needs a trace event which is not yet merged.

That patch can be find here:
https://patchwork.kernel.org/patch/10881305/

Unlike previous version, this version is based on trace events.
As long as we have btrfs_tree_lock() and btrfs_tree_read_lock() events,
we can using trace events to get all the needed info.

Compared to previous in-kernel version, this one has better resolution.
For example, we have an event whose
start_ns =3D 100ns end_ns=3D200,000,000ns (200ms) interval=3D100ms.

In previous in-kernel version, we will put all that 200ms latency into
the checkpoint 200ms.

While in this version, we will put (100ms - 100ns) into checkpoint
100ms, while another 100ms into checkpoint 200ms.

Some test result can be found in google doc:
https://docs.google.com/spreadsheets/d/1B5ETQNMq2plIcWBgEJZ5ap6NnXcAu2A4g=
TogGltlq4E/edit?usp=3Dsharing


The script starts below:

#!/usr/bin/python2
# @lint-avoid-python-3-compatibility-imports

from __future__ import print_function
from bcc import BPF
from sys import stderr

text_bpf =3D '''
#include <uapi/linux/ptrace.h>
#define FSID_SIZE   16

struct data_t {
    u8  fsid[FSID_SIZE];
    u64 start_ns;
    u64 end_ns;
    u64 owner;
};

BPF_PERF_OUTPUT(events);

TRACEPOINT_PROBE(btrfs, btrfs_tree_read_lock)
{
    struct data_t data;

    bpf_probe_read(data.fsid, FSID_SIZE, args->fsid);
    data.start_ns =3D args->start_ns;
    data.end_ns =3D args->end_ns;
    data.owner =3D args->owner;
    events.perf_submit(args, &data ,sizeof(data));
    return 0;
}

TRACEPOINT_PROBE(btrfs, btrfs_tree_lock)
{
    struct data_t data;

    bpf_probe_read(data.fsid, FSID_SIZE, args->fsid);
    data.start_ns =3D args->start_ns;
    data.end_ns =3D args->end_ns;
    data.owner =3D args->owner;
    events.perf_submit(args, &data ,sizeof(data));
    return 0;
}
'''

def is_fstree(owner):
    if owner =3D=3D 5 or (owner >=3D 256 and owner <=3D (2 ** 64 - 256)):=

        return True
    return False

# TODO: Don't use such classification while have a good idea to output
# all the needed info
def get_owner_str(owner):
    if is_fstree(owner):
        return 'SUBVOL'
    if owner =3D=3D 1:
        return 'TREE_ROOT'
    if owner =3D=3D 2:
        return 'EXTENT_ROOT'
    return 'OTHER_ROOTS'


'''
Sparse dict where access to hole (non-exist) key will return 0
other than raise an exception
'''
class sparse_dict:
    data_dict =3D {}
    def __init__(self):
        self.data_dict =3D {}

    def __getitem__(self, key):
        if key not in self.data_dict:
            return 0
        return self.data_dict[key]

    def __setitem__(self, key, value):
        self.data_dict[key] =3D value;

    def __contains__(self, key):
        return (key in self.data_dict)


def process_event(cpu, data, size):
    event =3D b["events"].event(data)

    global start_time_set
    global start_time
    global end_time
    global time_interval
    global results

    cur =3D int(event.start_ns / time_interval) * time_interval
    if start_time_set:
        start_time =3D min(cur, start_time)
    else:
        start_time =3D cur
        start_time_set =3D True
    end_time =3D max(event.end_ns, end_time)

    while cur < event.end_ns:
        end_ns =3D min(event.end_ns, cur + time_interval)
        start_ns =3D max(cur, event.start_ns)

        if cur not in results:
            results[cur] =3D sparse_dict()

        results[cur][get_owner_str(event.owner)] +=3D end_ns - start_ns
        cur +=3D time_interval

'''
output format (csv):
<aligned timestamp>, <tree root ns>, <extent root ns>, <subvol ns>,
<other ns>
'''
def print_results():
    print(file=3Dstderr)
    if not start_time_set:
        print("no data", file=3Dstderr)
        exit()
    cur =3D start_time
    print("%s,%s,%s,%s,%s" % ("timestamp", "root", "extent", "subvol",
"other"))
    while cur < end_time:
        if cur not in results:
            print("%d,%d,%d,%d,%d" % (cur - start_time, 0, 0, 0, 0))
        else:
            print("%d,%d,%d,%d,%d" % (cur - start_time,
                results[cur]['SUBVOL'],
                results[cur]['TREE_ROOT'],
                results[cur]['EXTENT_ROOT'],
                results[cur]['OTHER_ROOTS']))
        cur +=3D time_interval

# default time interval is 100ms
time_interval =3D 100 * 1000 * 1000

# @results is a 2 dimension dict.
# [<aligned_timetamp>][<owner_str>] to access, no need to
# worry about non-exist key.
results =3D sparse_dict()

# To catch the first event time stamp
start_time_set =3D False
start_time =3D False

end_time =3D 0


b =3D BPF(text =3D text_bpf)
b["events"].open_perf_buffer(process_event, page_cnt=3D64)
print("start recording", file=3Dstderr)
while 1:
    try:
        b.perf_buffer_poll()
    except KeyboardInterrupt:
        print_results()
        exit()


--wd2ohWURGFRLy8GbciPuxQGZccDPV0zba--

--wa7X5cckpP9kyNIscjGKu9wGQQsrHr2EW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyrAQ8ACgkQwj2R86El
/qgM+Qf9ErG+fgA8SmX5b2Lg/h/uIuGfFzY3GJ4rkMlGaDpxKX2MR7sUorFnXnH4
359iQcVqH/jRzEBgmrhuh3CBMm5WSiDgVSKbgLT9qQKMj4vY8BjUn1Wy1VFqVf7Y
NwVYaksum/04VsCjED+g52YU9iN87ooKR2Bv9dtcN/hYTEuPcjNFdMrYMk2oypDB
evTd9J42yFMt6szHJrAR7h41T/o4FFTbsVseDLae3HbltEv8os2eT9xeRaPlhlsb
9J6r/7aCwe7fZCHd8MJ2R7HN70DK6W5xEDmhwxTVsBG0FTQXsUujV4SAaCtiP+vu
sjjz7yeZA/MrTRQkhrXI9F+QfR7UHw==
=7TX/
-----END PGP SIGNATURE-----

--wa7X5cckpP9kyNIscjGKu9wGQQsrHr2EW--
