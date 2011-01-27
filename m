From: Shawn Stricker <kb1ibt@me.com>
Subject: Re: full btrfs partition,
 became unmountable (+ a solution that thankfully worked for me)
Date: Thu, 27 Jan 2011 01:18:52 -0500
Message-ID: <C6F9866B-F632-4A8A-BCA0-5BA44338FA21@me.com>
References: <1295981200.29117.19.camel@hestia>
 <BC28BE23-1017-456E-9EAA-74A840809085@me.com>
 <1296027969.29117.26.camel@hestia>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_g03Wb103Wo1xzIV/1OQH9A)"
Cc: =?iso-8859-1?Q?Cyrille_Ch=E9p=E9lov?= <cyrille@chepelov.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <1296027969.29117.26.camel@hestia>
List-ID: <linux-btrfs.vger.kernel.org>


--Boundary_(ID_g03Wb103Wo1xzIV/1OQH9A)
Content-type: text/plain; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT

any chance of getting a little more informative output?
I started the command at about 2250 Eastern and now at 0117 Eastern the command is still running and all of the attached output happened in the first few minutes (under 5).

--Boundary_(ID_g03Wb103Wo1xzIV/1OQH9A)
Content-type: text/plain; x-unix-mode=0700; name=output.txt
Content-transfer-encoding: 7BIT
Content-disposition: attachment; filename=output.txt

btrfsck /dev/sde
trying potential super #0 at bytenr 65536 
super #0 at bytenr 65536 has better generation 134838 than 0, using that
trying potential super #1 at bytenr 67108864 
super #1 at bytenr 67108864 has same generation 134838 than 134838, skipping
   warning: super #1 at bytenr 67108864 has different contents!
trying potential super #2 at bytenr 274877906944 
super #2 at bytenr 274877906944 has same generation 134838 than 134838, skipping
   warning: super #2 at bytenr 274877906944 has different contents!
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 8679965255889070385
trying potential super #1 at bytenr 67108864 
    misplaced block thinks it's at 11385464139938791651
trying potential super #2 at bytenr 274877906944 
    misplaced block thinks it's at 9270412280288921994
trying potential super #0 at bytenr 65536 
super #0 at bytenr 65536 has better generation 2155 than 0, using that
trying potential super #1 at bytenr 67108864 
    misplaced block thinks it's at 7739426643357674384
trying potential super #2 at bytenr 274877906944 
    misplaced block thinks it's at 15592201610856999042
trying potential super #0 at bytenr 65536 
super #0 at bytenr 65536 has better generation 134838 than 0, using that
trying potential super #1 at bytenr 67108864 
super #1 at bytenr 67108864 has same generation 134838 than 134838, skipping
   warning: super #1 at bytenr 67108864 has different contents!
trying potential super #2 at bytenr 274877906944 
super #2 at bytenr 274877906944 has same generation 134838 than 134838, skipping
   warning: super #2 at bytenr 274877906944 has different contents!
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 13794433748072589868
trying potential super #1 at bytenr 67108864 
    misplaced block thinks it's at 6338804170709571794
trying potential super #2 at bytenr 274877906944 
    misplaced block thinks it's at 1827607198315921929
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864 
    misplaced block thinks it's at 1254821329273892037
trying potential super #2 at bytenr 274877906944 
    misplaced block thinks it's at 5355923006792833603
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 15445565961457297964
trying potential super #1 at bytenr 67108864 
    misplaced block thinks it's at 3079817357236378973
trying potential super #2 at bytenr 274877906944 
    misplaced block thinks it's at 2007935378006179730
trying potential super #0 at bytenr 65536 
    invalid magic
trying potential super #1 at bytenr 67108864 
    misplaced block thinks it's at 5729257636792198197
trying potential super #2 at bytenr 274877906944 
    misplaced block thinks it's at 9602773462471183673
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 327680
trying potential super #1 at bytenr 67108864 
    misplaced block thinks it's at 0
trying potential super #2 at bytenr 274877906944 
    misplaced block thinks it's at 18446744073709551615
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864 
    misplaced block thinks it's at 0
trying potential super #2 at bytenr 274877906944 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864 
    misplaced block thinks it's at 0
trying potential super #2 at bytenr 274877906944 
    misplaced block thinks it's at 4313900536667142911
trying potential super #0 at bytenr 65536 
super #0 at bytenr 65536 has better generation 134838 than 0, using that
trying potential super #1 at bytenr 67108864 
super #1 at bytenr 67108864 has same generation 134838 than 134838, skipping
   warning: super #1 at bytenr 67108864 has different contents!
trying potential super #2 at bytenr 274877906944 
super #2 at bytenr 274877906944 has same generation 134838 than 134838, skipping
   warning: super #2 at bytenr 274877906944 has different contents!
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 1142399309793345613
trying potential super #1 at bytenr 67108864 
    misplaced block thinks it's at 6887355887353813266
trying potential super #2 at bytenr 274877906944 
    misplaced block thinks it's at 10874904992214108498
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 8679965255889070385
trying potential super #1 at bytenr 67108864 
    misplaced block thinks it's at 16378195527537296748
trying potential super #2 at bytenr 274877906944 
    misplaced block thinks it's at 9378314511156802577
trying potential super #0 at bytenr 65536 
super #0 at bytenr 65536 has better generation 129195 than 0, using that
trying potential super #1 at bytenr 67108864 
super #1 at bytenr 67108864 has same generation 129195 than 129195, skipping
   warning: super #1 at bytenr 67108864 has different contents!
trying potential super #2 at bytenr 274877906944 
super #2 at bytenr 274877906944 has same generation 129195 than 129195, skipping
   warning: super #2 at bytenr 274877906944 has different contents!
trying potential super #0 at bytenr 65536 
super #0 at bytenr 65536 has better generation 134838 than 0, using that
trying potential super #1 at bytenr 67108864 
super #1 at bytenr 67108864 has same generation 134838 than 134838, skipping
   warning: super #1 at bytenr 67108864 has different contents!
trying potential super #2 at bytenr 274877906944 
super #2 at bytenr 274877906944 has same generation 134838 than 134838, skipping
   warning: super #2 at bytenr 274877906944 has different contents!
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 18202071404685
trying potential super #1 at bytenr 67108864 
    misplaced block thinks it's at 3859474551985562464
trying potential super #2 at bytenr 274877906944 
    misplaced block thinks it's at 1690337285292802040
failed to read /dev/sr0
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 58309515406157858
trying potential super #1 at bytenr 67108864 
    misplaced block thinks it's at 14974415773995368456
trying potential super #2 at bytenr 274877906944 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864 
    misplaced block thinks it's at 7579404676876747853
trying potential super #2 at bytenr 274877906944 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864 
    misplaced block thinks it's at 4478649175259584457
trying potential super #2 at bytenr 274877906944 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
super #0 at bytenr 65536 has better generation 134838 than 0, using that
trying potential super #1 at bytenr 67108864 
super #1 at bytenr 67108864 has same generation 134838 than 134838, skipping
   warning: super #1 at bytenr 67108864 has different contents!
trying potential super #2 at bytenr 274877906944 
super #2 at bytenr 274877906944 has same generation 134838 than 134838, skipping
   warning: super #2 at bytenr 274877906944 has different contents!
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 8679965255889070385
trying potential super #1 at bytenr 67108864 
    misplaced block thinks it's at 11385464139938791651
trying potential super #2 at bytenr 274877906944 
    misplaced block thinks it's at 9270412280288921994
trying potential super #0 at bytenr 65536 
super #0 at bytenr 65536 has better generation 2155 than 0, using that
trying potential super #1 at bytenr 67108864 
    misplaced block thinks it's at 7739426643357674384
trying potential super #2 at bytenr 274877906944 
    misplaced block thinks it's at 15592201610856999042
trying potential super #0 at bytenr 65536 
super #0 at bytenr 65536 has better generation 134838 than 0, using that
trying potential super #1 at bytenr 67108864 
super #1 at bytenr 67108864 has same generation 134838 than 134838, skipping
   warning: super #1 at bytenr 67108864 has different contents!
trying potential super #2 at bytenr 274877906944 
super #2 at bytenr 274877906944 has same generation 134838 than 134838, skipping
   warning: super #2 at bytenr 274877906944 has different contents!
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 13794433748072589868
trying potential super #1 at bytenr 67108864 
    misplaced block thinks it's at 6338804170709571794
trying potential super #2 at bytenr 274877906944 
    misplaced block thinks it's at 1827607198315921929
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864 
    misplaced block thinks it's at 1254821329273892037
trying potential super #2 at bytenr 274877906944 
    misplaced block thinks it's at 5355923006792833603
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 15445565961457297964
trying potential super #1 at bytenr 67108864 
    misplaced block thinks it's at 3079817357236378973
trying potential super #2 at bytenr 274877906944 
    misplaced block thinks it's at 2007935378006179730
trying potential super #0 at bytenr 65536 
    invalid magic
trying potential super #1 at bytenr 67108864 
    misplaced block thinks it's at 5729257636792198197
trying potential super #2 at bytenr 274877906944 
    misplaced block thinks it's at 9602773462471183673
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 327680
trying potential super #1 at bytenr 67108864 
    misplaced block thinks it's at 0
trying potential super #2 at bytenr 274877906944 
    misplaced block thinks it's at 18446744073709551615
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864 
    misplaced block thinks it's at 0
trying potential super #2 at bytenr 274877906944 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864 
    misplaced block thinks it's at 0
trying potential super #2 at bytenr 274877906944 
    misplaced block thinks it's at 4313900536667142911
trying potential super #0 at bytenr 65536 
super #0 at bytenr 65536 has better generation 134838 than 0, using that
trying potential super #1 at bytenr 67108864 
super #1 at bytenr 67108864 has same generation 134838 than 134838, skipping
   warning: super #1 at bytenr 67108864 has different contents!
trying potential super #2 at bytenr 274877906944 
super #2 at bytenr 274877906944 has same generation 134838 than 134838, skipping
   warning: super #2 at bytenr 274877906944 has different contents!
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 1142399309793345613
trying potential super #1 at bytenr 67108864 
    misplaced block thinks it's at 6887355887353813266
trying potential super #2 at bytenr 274877906944 
    misplaced block thinks it's at 10874904992214108498
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 8679965255889070385
trying potential super #1 at bytenr 67108864 
    misplaced block thinks it's at 16378195527537296748
trying potential super #2 at bytenr 274877906944 
    misplaced block thinks it's at 9378314511156802577
trying potential super #0 at bytenr 65536 
super #0 at bytenr 65536 has better generation 129195 than 0, using that
trying potential super #1 at bytenr 67108864 
super #1 at bytenr 67108864 has same generation 129195 than 129195, skipping
   warning: super #1 at bytenr 67108864 has different contents!
trying potential super #2 at bytenr 274877906944 
super #2 at bytenr 274877906944 has same generation 129195 than 129195, skipping
   warning: super #2 at bytenr 274877906944 has different contents!
trying potential super #0 at bytenr 65536 
super #0 at bytenr 65536 has better generation 134838 than 0, using that
trying potential super #1 at bytenr 67108864 
super #1 at bytenr 67108864 has same generation 134838 than 134838, skipping
   warning: super #1 at bytenr 67108864 has different contents!
trying potential super #2 at bytenr 274877906944 
super #2 at bytenr 274877906944 has same generation 134838 than 134838, skipping
   warning: super #2 at bytenr 274877906944 has different contents!
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 18202071404685
trying potential super #1 at bytenr 67108864 
    misplaced block thinks it's at 3859474551985562464
trying potential super #2 at bytenr 274877906944 
    misplaced block thinks it's at 1690337285292802040
failed to read /dev/sr0
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 58309515406157858
trying potential super #1 at bytenr 67108864 
    misplaced block thinks it's at 14974415773995368456
trying potential super #2 at bytenr 274877906944 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864 
    misplaced block thinks it's at 7579404676876747853
trying potential super #2 at bytenr 274877906944 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864 
    misplaced block thinks it's at 4478649175259584457
trying potential super #2 at bytenr 274877906944 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864 
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536 
super #0 at bytenr 65536 has better generation 134838 than 0, using that
trying potential super #1 at bytenr 67108864 
super #1 at bytenr 67108864 has same generation 134838 than 134838, skipping
   warning: super #1 at bytenr 67108864 has different contents!
trying potential super #2 at bytenr 274877906944 
super #2 at bytenr 274877906944 has same generation 134838 than 134838, skipping
   warning: super #2 at bytenr 274877906944 has different contents!
parent transid verify failed on 12608758878208 wanted 134838 found 134835
parent transid verify failed on 12608758878208 wanted 134838 found 134835
*** did not find a root, about to abort ***
*** will attempt to find useful trees before bailing out anyway: ***
     found valid header at 131072(+65536) -- gen=134834 owner=3 nritems=33 level=1  ... new best gen for ObjectID 3  at 131072
     found valid header at 1118208(+835584) -- gen=1 owner=1 nritems=4 level=0  ... new best gen for ObjectID 1  at 1118208
     found valid header at 1122304(+4096) -- gen=1 owner=2 nritems=12 level=0  ... new best gen for ObjectID 2  at 1122304
     found valid header at 1130496(+4096) -- gen=1 owner=4 nritems=1 level=0  ... new best gen for ObjectID 4  at 1130496
     found valid header at 1134592(+4096) -- gen=1 owner=5 nritems=0 level=0  ... new best gen for ObjectID 5  at 1134592
     found valid header at 1138688(+4096) -- gen=1 owner=7 nritems=0 level=0  ... new best gen for ObjectID 7  at 1138688


--Boundary_(ID_g03Wb103Wo1xzIV/1OQH9A)
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: quoted-printable


On Jan 26, 2011, at 2:46 AM, Cyrille Ch=E9p=E9lov wrote:

> Le mardi 25 janvier 2011 =E0 23:38 -0500, Shawn Stricker a =E9crit :
>> Not sure where you pulled your source from but a fresh checkout of =
either master or next of =
git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.git =
does not compile properly.
>> They both fail with=20
>>=20
>> cc1: warnings being treated as errors
>> disk-io.c: In function =91btrfs_read_dev_super=92:
>> disk-io.c:937: error: format =91%lu=92 expects type =91long unsigned =
int=92, but argument 4 has type =91unsigned int=92
>> disk-io.c:957: error: implicit declaration of function =91uuid_unparse=92=

>>=20
>> am I patching/compiling from the wrong source or is there something I =
am missing?
>=20
> uh, I had been compiling with CFLAGS=3D-g, where the makefile =
specifies
> "-O2 -Werror"
>=20
> -Werror causes warnings to be treated as errors, which is a good thing
> in a way (makes sure stuff as this gets caught :) )
>=20
> fixes are:
> 	* line 937 (patched), should be %llu instead of %lu
> 	* line 957, there should be a prototype for uuid_unparse(), most
> certainly by including <uuid/uuid.h>
>=20
> please try this patch instead.
>=20
> Thanks for the feedback!
>=20
> 	-- Cyrille
>=20
>> On Jan 25, 2011, at 1:46 PM, Cyrille Ch=E9p=E9lov wrote:
>>=20
>>> Hello all,
>>>=20
>>> Last Friday, the /var and /home partition on one of my appliances =
became
>>> full. This should normally not be much of a problem, except that =
after
>>> the incident, I had been unable to mount the partition back again.
>>>=20
>>> The appliance runs 2.6.32 as provided by Debian during the last two
>>> months.=20
>>> The rescue computer runs 2.6.37; both exhibited the same behaviour =
at
>>> mount: an infinite loop-and-abort cycle (I unfortunately did not =
write
>>> down the exact messages, but in a nutshell, there was not enough =
free
>>> space to replay the log, so it aborted).
>>>=20
>>> After pulling the SD card (yes) to break the loop, I ended up with a
>>> corrupt file system. Any attempt to mount, debug or fsck (using
>>> btrfs-tools 0.19+20100601 as shipped by Debian, or compiled from git
>>> 1b444cd2e6ab8dcafdd) aborted with the following message:
>>>   btrfs-debug-tree: disk-io.c:741: open_ctree_fd: Assertion `!(!
>>> tree_root->node)' failed.
>>>=20
>>> After much scavenging on the disk image, I finally managed to =
recover,
>>> using the (dirty) patch attached here. Since apparently other people =
had
>>> similar issues, I'm posting it in the hope it might be useful.
>>>=20
>>>   -- Cyrille
>>>=20
>>> PS: Chris, if btrfs-images of "before" and "after" my butcher fix =
would
>>> be useful to you, just let me know.=20
>>> <scavenge.patch>
>>=20
>=20
> <scavenge-2.patch>


--Boundary_(ID_g03Wb103Wo1xzIV/1OQH9A)--
