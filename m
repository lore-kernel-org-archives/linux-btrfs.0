Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f193.google.com ([209.85.217.193]:34217 "EHLO
	mail-lb0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbbL1B46 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Dec 2015 20:56:58 -0500
Received: by mail-lb0-f193.google.com with SMTP id jk7so5525750lbc.1
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Dec 2015 17:56:57 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 27 Dec 2015 20:56:56 -0500
Message-ID: <CA+X5Wn6i-JdcEtz1UaKnQgxarxMxhqNUJk5-BWctasJHgKy4SQ@mail.gmail.com>
Subject: Re: corrupt leaf, bad key order & no csum found for inode & csum
 failed ino & input/output error
From: james harvey <jamespharvey20@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Contents of btrfs-debug-tree are below.  item 293 (which I'm assuming
is what "slot=292" refers to with a start-of-index difference) shows:

item 292 key (EXTENT_CSUM EXTENT_CSUM 250718826496) itemoff 10231 itemsize 4
extent csum item
item 293 key (18446744073709551350 EXTENT_CSUM 250718830592) itemoff
10207 itemsize 24
extent csum item
item 294 key (EXTENT_CSUM EXTENT_CSUM 250719469568) itemoff 10203 itemsize 4
extent csum item


WHOLE THING FOLLOWS
====================

$ sudo btrfs-debug-tree -b 241468833792 /dev/sda2
leaf 241468833792 items 361 free space 6 generation 145329 owner 7
fs uuid 535e3d41-989e-4c14-a837-536d79e4ff51
chunk uuid 606ea16e-ad28-4fa5-af00-9915a767124d
item 0 key (EXTENT_CSUM EXTENT_CSUM 250698342400) itemoff 16263 itemsize 20
extent csum item
item 1 key (EXTENT_CSUM EXTENT_CSUM 250698362880) itemoff 16255 itemsize 8
extent csum item
item 2 key (EXTENT_CSUM EXTENT_CSUM 250698371072) itemoff 16235 itemsize 20
extent csum item
item 3 key (EXTENT_CSUM EXTENT_CSUM 250698391552) itemoff 16231 itemsize 4
extent csum item
item 4 key (EXTENT_CSUM EXTENT_CSUM 250698395648) itemoff 16227 itemsize 4
extent csum item
item 5 key (EXTENT_CSUM EXTENT_CSUM 250698399744) itemoff 16207 itemsize 20
extent csum item
item 6 key (EXTENT_CSUM EXTENT_CSUM 250698420224) itemoff 16199 itemsize 8
extent csum item
item 7 key (EXTENT_CSUM EXTENT_CSUM 250698428416) itemoff 16179 itemsize 20
extent csum item
item 8 key (EXTENT_CSUM EXTENT_CSUM 250698448896) itemoff 16175 itemsize 4
extent csum item
item 9 key (EXTENT_CSUM EXTENT_CSUM 250698452992) itemoff 16171 itemsize 4
extent csum item
item 10 key (EXTENT_CSUM EXTENT_CSUM 250698457088) itemoff 16163 itemsize 8
extent csum item
item 11 key (EXTENT_CSUM EXTENT_CSUM 250698473472) itemoff 16151 itemsize 12
extent csum item
item 12 key (EXTENT_CSUM EXTENT_CSUM 250698485760) itemoff 16131 itemsize 20
extent csum item
item 13 key (EXTENT_CSUM EXTENT_CSUM 250698506240) itemoff 16127 itemsize 4
extent csum item
item 14 key (EXTENT_CSUM EXTENT_CSUM 250698514432) itemoff 16119 itemsize 8
extent csum item
item 15 key (EXTENT_CSUM EXTENT_CSUM 250698522624) itemoff 16107 itemsize 12
extent csum item
item 16 key (EXTENT_CSUM EXTENT_CSUM 250698534912) itemoff 16103 itemsize 4
extent csum item
item 17 key (EXTENT_CSUM EXTENT_CSUM 250698539008) itemoff 16087 itemsize 16
extent csum item
item 18 key (EXTENT_CSUM EXTENT_CSUM 250698555392) itemoff 16055 itemsize 32
extent csum item
item 19 key (EXTENT_CSUM EXTENT_CSUM 250698588160) itemoff 16051 itemsize 4
extent csum item
item 20 key (EXTENT_CSUM EXTENT_CSUM 250698596352) itemoff 16039 itemsize 12
extent csum item
item 21 key (EXTENT_CSUM EXTENT_CSUM 250698608640) itemoff 16035 itemsize 4
extent csum item
item 22 key (EXTENT_CSUM EXTENT_CSUM 250698612736) itemoff 16023 itemsize 12
extent csum item
item 23 key (EXTENT_CSUM EXTENT_CSUM 250698637312) itemoff 16011 itemsize 12
extent csum item
item 24 key (EXTENT_CSUM EXTENT_CSUM 250698649600) itemoff 16007 itemsize 4
extent csum item
item 25 key (EXTENT_CSUM EXTENT_CSUM 250698788864) itemoff 15995 itemsize 12
extent csum item
item 26 key (EXTENT_CSUM EXTENT_CSUM 250698801152) itemoff 15991 itemsize 4
extent csum item
item 27 key (EXTENT_CSUM EXTENT_CSUM 250698829824) itemoff 15979 itemsize 12
extent csum item
item 28 key (EXTENT_CSUM EXTENT_CSUM 250698878976) itemoff 15935 itemsize 44
extent csum item
item 29 key (EXTENT_CSUM EXTENT_CSUM 250698924032) itemoff 15907 itemsize 28
extent csum item
item 30 key (EXTENT_CSUM EXTENT_CSUM 250698952704) itemoff 15895 itemsize 12
extent csum item
item 31 key (EXTENT_CSUM EXTENT_CSUM 250698964992) itemoff 15887 itemsize 8
extent csum item
item 32 key (EXTENT_CSUM EXTENT_CSUM 250698973184) itemoff 15879 itemsize 8
extent csum item
item 33 key (EXTENT_CSUM EXTENT_CSUM 250698981376) itemoff 15871 itemsize 8
extent csum item
item 34 key (EXTENT_CSUM EXTENT_CSUM 250698989568) itemoff 15863 itemsize 8
extent csum item
item 35 key (EXTENT_CSUM EXTENT_CSUM 250699001856) itemoff 15859 itemsize 4
extent csum item
item 36 key (EXTENT_CSUM EXTENT_CSUM 250699014144) itemoff 15851 itemsize 8
extent csum item
item 37 key (EXTENT_CSUM EXTENT_CSUM 250699022336) itemoff 15835 itemsize 16
extent csum item
item 38 key (EXTENT_CSUM EXTENT_CSUM 250699038720) itemoff 15831 itemsize 4
extent csum item
item 39 key (EXTENT_CSUM EXTENT_CSUM 250699046912) itemoff 15823 itemsize 8
extent csum item
item 40 key (EXTENT_CSUM EXTENT_CSUM 250699055104) itemoff 15811 itemsize 12
extent csum item
item 41 key (EXTENT_CSUM EXTENT_CSUM 250699067392) itemoff 15791 itemsize 20
extent csum item
item 42 key (EXTENT_CSUM EXTENT_CSUM 250699091968) itemoff 15787 itemsize 4
extent csum item
item 43 key (EXTENT_CSUM EXTENT_CSUM 250699096064) itemoff 15783 itemsize 4
extent csum item
item 44 key (EXTENT_CSUM EXTENT_CSUM 250699100160) itemoff 15763 itemsize 20
extent csum item
item 45 key (EXTENT_CSUM EXTENT_CSUM 250699120640) itemoff 15747 itemsize 16
extent csum item
item 46 key (EXTENT_CSUM EXTENT_CSUM 250699137024) itemoff 15727 itemsize 20
extent csum item
item 47 key (EXTENT_CSUM EXTENT_CSUM 250699161600) itemoff 15715 itemsize 12
extent csum item
item 48 key (EXTENT_CSUM EXTENT_CSUM 250699173888) itemoff 15699 itemsize 16
extent csum item
item 49 key (EXTENT_CSUM EXTENT_CSUM 250699190272) itemoff 15691 itemsize 8
extent csum item
item 50 key (EXTENT_CSUM EXTENT_CSUM 250699198464) itemoff 15671 itemsize 20
extent csum item
item 51 key (EXTENT_CSUM EXTENT_CSUM 250699218944) itemoff 15655 itemsize 16
extent csum item
item 52 key (EXTENT_CSUM EXTENT_CSUM 250699235328) itemoff 15651 itemsize 4
extent csum item
item 53 key (EXTENT_CSUM EXTENT_CSUM 250699239424) itemoff 15639 itemsize 12
extent csum item
item 54 key (EXTENT_CSUM EXTENT_CSUM 250699251712) itemoff 15635 itemsize 4
extent csum item
item 55 key (EXTENT_CSUM EXTENT_CSUM 250699255808) itemoff 15619 itemsize 16
extent csum item
item 56 key (EXTENT_CSUM EXTENT_CSUM 250699272192) itemoff 15599 itemsize 20
extent csum item
item 57 key (EXTENT_CSUM EXTENT_CSUM 250699292672) itemoff 15531 itemsize 68
extent csum item
item 58 key (EXTENT_CSUM EXTENT_CSUM 250699362304) itemoff 15503 itemsize 28
extent csum item
item 59 key (EXTENT_CSUM EXTENT_CSUM 250699390976) itemoff 15499 itemsize 4
extent csum item
item 60 key (EXTENT_CSUM EXTENT_CSUM 250699399168) itemoff 15463 itemsize 36
extent csum item
item 61 key (EXTENT_CSUM EXTENT_CSUM 250699440128) itemoff 15459 itemsize 4
extent csum item
item 62 key (EXTENT_CSUM EXTENT_CSUM 250699448320) itemoff 15447 itemsize 12
extent csum item
item 63 key (EXTENT_CSUM EXTENT_CSUM 250699464704) itemoff 15443 itemsize 4
extent csum item
item 64 key (EXTENT_CSUM EXTENT_CSUM 250699468800) itemoff 15427 itemsize 16
extent csum item
item 65 key (EXTENT_CSUM EXTENT_CSUM 250699485184) itemoff 15419 itemsize 8
extent csum item
item 66 key (EXTENT_CSUM EXTENT_CSUM 250699497472) itemoff 15403 itemsize 16
extent csum item
item 67 key (EXTENT_CSUM EXTENT_CSUM 250699513856) itemoff 15395 itemsize 8
extent csum item
item 68 key (EXTENT_CSUM EXTENT_CSUM 250699530240) itemoff 15387 itemsize 8
extent csum item
item 69 key (EXTENT_CSUM EXTENT_CSUM 250699542528) itemoff 15267 itemsize 120
extent csum item
item 70 key (EXTENT_CSUM EXTENT_CSUM 250699673600) itemoff 15235 itemsize 32
extent csum item
item 71 key (EXTENT_CSUM EXTENT_CSUM 250699706368) itemoff 15211 itemsize 24
extent csum item
item 72 key (EXTENT_CSUM EXTENT_CSUM 250699735040) itemoff 15207 itemsize 4
extent csum item
item 73 key (EXTENT_CSUM EXTENT_CSUM 250699743232) itemoff 15195 itemsize 12
extent csum item
item 74 key (EXTENT_CSUM EXTENT_CSUM 250699759616) itemoff 15191 itemsize 4
extent csum item
item 75 key (EXTENT_CSUM EXTENT_CSUM 250699767808) itemoff 15183 itemsize 8
extent csum item
item 76 key (EXTENT_CSUM EXTENT_CSUM 250699776000) itemoff 15175 itemsize 8
extent csum item
item 77 key (EXTENT_CSUM EXTENT_CSUM 250699788288) itemoff 15171 itemsize 4
extent csum item
item 78 key (EXTENT_CSUM EXTENT_CSUM 250699792384) itemoff 15163 itemsize 8
extent csum item
item 79 key (EXTENT_CSUM EXTENT_CSUM 250699800576) itemoff 15155 itemsize 8
extent csum item
item 80 key (EXTENT_CSUM EXTENT_CSUM 250699808768) itemoff 15147 itemsize 8
extent csum item
item 81 key (EXTENT_CSUM EXTENT_CSUM 250699816960) itemoff 15139 itemsize 8
extent csum item
item 82 key (EXTENT_CSUM EXTENT_CSUM 250699829248) itemoff 15135 itemsize 4
extent csum item
item 83 key (EXTENT_CSUM EXTENT_CSUM 250699833344) itemoff 15115 itemsize 20
extent csum item
item 84 key (EXTENT_CSUM EXTENT_CSUM 250699866112) itemoff 15107 itemsize 8
extent csum item
item 85 key (EXTENT_CSUM EXTENT_CSUM 250699874304) itemoff 15075 itemsize 32
extent csum item
item 86 key (EXTENT_CSUM EXTENT_CSUM 250699907072) itemoff 15067 itemsize 8
extent csum item
item 87 key (EXTENT_CSUM EXTENT_CSUM 250699927552) itemoff 15047 itemsize 20
extent csum item
item 88 key (EXTENT_CSUM EXTENT_CSUM 250699952128) itemoff 15039 itemsize 8
extent csum item
item 89 key (EXTENT_CSUM EXTENT_CSUM 250699960320) itemoff 15031 itemsize 8
extent csum item
item 90 key (EXTENT_CSUM EXTENT_CSUM 250699968512) itemoff 15027 itemsize 4
extent csum item
item 91 key (EXTENT_CSUM EXTENT_CSUM 250699972608) itemoff 15007 itemsize 20
extent csum item
item 92 key (EXTENT_CSUM EXTENT_CSUM 250700001280) itemoff 14995 itemsize 12
extent csum item
item 93 key (EXTENT_CSUM EXTENT_CSUM 250700021760) itemoff 14983 itemsize 12
extent csum item
item 94 key (EXTENT_CSUM EXTENT_CSUM 250700042240) itemoff 14967 itemsize 16
extent csum item
item 95 key (EXTENT_CSUM EXTENT_CSUM 250700058624) itemoff 14835 itemsize 132
extent csum item
item 96 key (EXTENT_CSUM EXTENT_CSUM 250700230656) itemoff 14819 itemsize 16
extent csum item
item 97 key (EXTENT_CSUM EXTENT_CSUM 250700251136) itemoff 14727 itemsize 92
extent csum item
item 98 key (EXTENT_CSUM EXTENT_CSUM 250700345344) itemoff 14671 itemsize 56
extent csum item
item 99 key (EXTENT_CSUM EXTENT_CSUM 250700402688) itemoff 14659 itemsize 12
extent csum item
item 100 key (EXTENT_CSUM EXTENT_CSUM 250700414976) itemoff 14655 itemsize 4
extent csum item
item 101 key (EXTENT_CSUM EXTENT_CSUM 250700419072) itemoff 14639 itemsize 16
extent csum item
item 102 key (EXTENT_CSUM EXTENT_CSUM 250700435456) itemoff 14587 itemsize 52
extent csum item
item 103 key (EXTENT_CSUM EXTENT_CSUM 250700488704) itemoff 14583 itemsize 4
extent csum item
item 104 key (EXTENT_CSUM EXTENT_CSUM 250700492800) itemoff 14575 itemsize 8
extent csum item
item 105 key (EXTENT_CSUM EXTENT_CSUM 250700500992) itemoff 14559 itemsize 16
extent csum item
item 106 key (EXTENT_CSUM EXTENT_CSUM 250700517376) itemoff 14547 itemsize 12
extent csum item
item 107 key (EXTENT_CSUM EXTENT_CSUM 250700529664) itemoff 14535 itemsize 12
extent csum item
item 108 key (EXTENT_CSUM EXTENT_CSUM 250700541952) itemoff 14527 itemsize 8
extent csum item
item 109 key (EXTENT_CSUM EXTENT_CSUM 250700554240) itemoff 14515 itemsize 12
extent csum item
item 110 key (EXTENT_CSUM EXTENT_CSUM 250700570624) itemoff 14511 itemsize 4
extent csum item
item 111 key (EXTENT_CSUM EXTENT_CSUM 250700574720) itemoff 14495 itemsize 16
extent csum item
item 112 key (EXTENT_CSUM EXTENT_CSUM 250700591104) itemoff 14487 itemsize 8
extent csum item
item 113 key (EXTENT_CSUM EXTENT_CSUM 250700599296) itemoff 14483 itemsize 4
extent csum item
item 114 key (EXTENT_CSUM EXTENT_CSUM 250700603392) itemoff 14475 itemsize 8
extent csum item
item 115 key (EXTENT_CSUM EXTENT_CSUM 250700611584) itemoff 14463 itemsize 12
extent csum item
item 116 key (EXTENT_CSUM EXTENT_CSUM 250700623872) itemoff 14459 itemsize 4
extent csum item
item 117 key (EXTENT_CSUM EXTENT_CSUM 250700627968) itemoff 14435 itemsize 24
extent csum item
item 118 key (EXTENT_CSUM EXTENT_CSUM 250700652544) itemoff 14427 itemsize 8
extent csum item
item 119 key (EXTENT_CSUM EXTENT_CSUM 250700660736) itemoff 14415 itemsize 12
extent csum item
item 120 key (EXTENT_CSUM EXTENT_CSUM 250700673024) itemoff 14411 itemsize 4
extent csum item
item 121 key (EXTENT_CSUM EXTENT_CSUM 250700808192) itemoff 14403 itemsize 8
extent csum item
item 122 key (EXTENT_CSUM EXTENT_CSUM 250700816384) itemoff 14379 itemsize 24
extent csum item
item 123 key (EXTENT_CSUM EXTENT_CSUM 250700845056) itemoff 14375 itemsize 4
extent csum item
item 124 key (EXTENT_CSUM EXTENT_CSUM 250700861440) itemoff 14371 itemsize 4
extent csum item
item 125 key (EXTENT_CSUM EXTENT_CSUM 250700869632) itemoff 14367 itemsize 4
extent csum item
item 126 key (EXTENT_CSUM EXTENT_CSUM 250700873728) itemoff 14359 itemsize 8
extent csum item
item 127 key (EXTENT_CSUM EXTENT_CSUM 250700881920) itemoff 14347 itemsize 12
extent csum item
item 128 key (EXTENT_CSUM EXTENT_CSUM 250700894208) itemoff 14307 itemsize 40
extent csum item
item 129 key (EXTENT_CSUM EXTENT_CSUM 250700935168) itemoff 14303 itemsize 4
extent csum item
item 130 key (EXTENT_CSUM EXTENT_CSUM 250700943360) itemoff 14283 itemsize 20
extent csum item
item 131 key (EXTENT_CSUM EXTENT_CSUM 250700963840) itemoff 14275 itemsize 8
extent csum item
item 132 key (EXTENT_CSUM EXTENT_CSUM 250700984320) itemoff 14255 itemsize 20
extent csum item
item 133 key (EXTENT_CSUM EXTENT_CSUM 250701008896) itemoff 14247 itemsize 8
extent csum item
item 134 key (EXTENT_CSUM EXTENT_CSUM 250701017088) itemoff 14239 itemsize 8
extent csum item
item 135 key (EXTENT_CSUM EXTENT_CSUM 250701025280) itemoff 14227 itemsize 12
extent csum item
item 136 key (EXTENT_CSUM EXTENT_CSUM 250701049856) itemoff 14219 itemsize 8
extent csum item
item 137 key (EXTENT_CSUM EXTENT_CSUM 250701058048) itemoff 14183 itemsize 36
extent csum item
item 138 key (EXTENT_CSUM EXTENT_CSUM 250701094912) itemoff 14179 itemsize 4
extent csum item
item 139 key (EXTENT_CSUM EXTENT_CSUM 250701103104) itemoff 14171 itemsize 8
extent csum item
item 140 key (EXTENT_CSUM EXTENT_CSUM 250701119488) itemoff 14139 itemsize 32
extent csum item
item 141 key (EXTENT_CSUM EXTENT_CSUM 250701152256) itemoff 14063 itemsize 76
extent csum item
item 142 key (EXTENT_CSUM EXTENT_CSUM 250701230080) itemoff 13995 itemsize 68
extent csum item
item 143 key (EXTENT_CSUM EXTENT_CSUM 250701299712) itemoff 13955 itemsize 40
extent csum item
item 144 key (EXTENT_CSUM EXTENT_CSUM 250701340672) itemoff 13875 itemsize 80
extent csum item
item 145 key (EXTENT_CSUM EXTENT_CSUM 250701438976) itemoff 13843 itemsize 32
extent csum item
item 146 key (EXTENT_CSUM EXTENT_CSUM 250701471744) itemoff 13259 itemsize 584
extent csum item
item 147 key (EXTENT_CSUM EXTENT_CSUM 250702348288) itemoff 13255 itemsize 4
extent csum item
item 148 key (EXTENT_CSUM EXTENT_CSUM 250702360576) itemoff 13251 itemsize 4
extent csum item
item 149 key (EXTENT_CSUM EXTENT_CSUM 250702450688) itemoff 13247 itemsize 4
extent csum item
item 150 key (EXTENT_CSUM EXTENT_CSUM 250702721024) itemoff 13243 itemsize 4
extent csum item
item 151 key (EXTENT_CSUM EXTENT_CSUM 250702864384) itemoff 13239 itemsize 4
extent csum item
item 152 key (EXTENT_CSUM EXTENT_CSUM 250703081472) itemoff 13227 itemsize 12
extent csum item
item 153 key (EXTENT_CSUM EXTENT_CSUM 250703220736) itemoff 13203 itemsize 24
extent csum item
item 154 key (EXTENT_CSUM EXTENT_CSUM 250703360000) itemoff 13199 itemsize 4
extent csum item
item 155 key (EXTENT_CSUM EXTENT_CSUM 250704109568) itemoff 13191 itemsize 8
extent csum item
item 156 key (EXTENT_CSUM EXTENT_CSUM 250704187392) itemoff 13175 itemsize 16
extent csum item
item 157 key (EXTENT_CSUM EXTENT_CSUM 250704510976) itemoff 13171 itemsize 4
extent csum item
item 158 key (EXTENT_CSUM EXTENT_CSUM 250704564224) itemoff 13167 itemsize 4
extent csum item
item 159 key (EXTENT_CSUM EXTENT_CSUM 250704744448) itemoff 13107 itemsize 60
extent csum item
item 160 key (EXTENT_CSUM EXTENT_CSUM 250704859136) itemoff 13087 itemsize 20
extent csum item
item 161 key (EXTENT_CSUM EXTENT_CSUM 250704908288) itemoff 13047 itemsize 40
extent csum item
item 162 key (EXTENT_CSUM EXTENT_CSUM 250704961536) itemoff 13039 itemsize 8
extent csum item
item 163 key (EXTENT_CSUM EXTENT_CSUM 250704986112) itemoff 13035 itemsize 4
extent csum item
item 164 key (EXTENT_CSUM EXTENT_CSUM 250705010688) itemoff 13015 itemsize 20
extent csum item
item 165 key (EXTENT_CSUM EXTENT_CSUM 250705588224) itemoff 12879 itemsize 136
extent csum item
item 166 key (EXTENT_CSUM EXTENT_CSUM 250706210816) itemoff 12875 itemsize 4
extent csum item
item 167 key (EXTENT_CSUM EXTENT_CSUM 250706808832) itemoff 12867 itemsize 8
extent csum item
item 168 key (EXTENT_CSUM EXTENT_CSUM 250706882560) itemoff 12863 itemsize 4
extent csum item
item 169 key (EXTENT_CSUM EXTENT_CSUM 250706935808) itemoff 12859 itemsize 4
extent csum item
item 170 key (EXTENT_CSUM EXTENT_CSUM 250706952192) itemoff 12851 itemsize 8
extent csum item
item 171 key (EXTENT_CSUM EXTENT_CSUM 250707058688) itemoff 12839 itemsize 12
extent csum item
item 172 key (EXTENT_CSUM EXTENT_CSUM 250707079168) itemoff 12603 itemsize 236
extent csum item
item 173 key (EXTENT_CSUM EXTENT_CSUM 250707324928) itemoff 12599 itemsize 4
extent csum item
item 174 key (EXTENT_CSUM EXTENT_CSUM 250707505152) itemoff 12595 itemsize 4
extent csum item
item 175 key (EXTENT_CSUM EXTENT_CSUM 250707615744) itemoff 12591 itemsize 4
extent csum item
item 176 key (EXTENT_CSUM EXTENT_CSUM 250707709952) itemoff 12587 itemsize 4
extent csum item
item 177 key (EXTENT_CSUM EXTENT_CSUM 250707726336) itemoff 12583 itemsize 4
extent csum item
item 178 key (EXTENT_CSUM EXTENT_CSUM 250707812352) itemoff 12579 itemsize 4
extent csum item
item 179 key (EXTENT_CSUM EXTENT_CSUM 250707865600) itemoff 12563 itemsize 16
extent csum item
item 180 key (EXTENT_CSUM EXTENT_CSUM 250707898368) itemoff 12559 itemsize 4
extent csum item
item 181 key (EXTENT_CSUM EXTENT_CSUM 250707972096) itemoff 12555 itemsize 4
extent csum item
item 182 key (EXTENT_CSUM EXTENT_CSUM 250708004864) itemoff 12547 itemsize 8
extent csum item
item 183 key (EXTENT_CSUM EXTENT_CSUM 250708135936) itemoff 12543 itemsize 4
extent csum item
item 184 key (EXTENT_CSUM EXTENT_CSUM 250708844544) itemoff 12539 itemsize 4
extent csum item
item 185 key (EXTENT_CSUM EXTENT_CSUM 250708905984) itemoff 12535 itemsize 4
extent csum item
item 186 key (EXTENT_CSUM EXTENT_CSUM 250709012480) itemoff 12527 itemsize 8
extent csum item
item 187 key (EXTENT_CSUM EXTENT_CSUM 250709053440) itemoff 12523 itemsize 4
extent csum item
item 188 key (EXTENT_CSUM EXTENT_CSUM 250709069824) itemoff 12519 itemsize 4
extent csum item
item 189 key (EXTENT_CSUM EXTENT_CSUM 250709172224) itemoff 12515 itemsize 4
extent csum item
item 190 key (EXTENT_CSUM EXTENT_CSUM 250709209088) itemoff 12507 itemsize 8
extent csum item
item 191 key (EXTENT_CSUM EXTENT_CSUM 250709295104) itemoff 12499 itemsize 8
extent csum item
item 192 key (EXTENT_CSUM EXTENT_CSUM 250709397504) itemoff 12495 itemsize 4
extent csum item
item 193 key (EXTENT_CSUM EXTENT_CSUM 250709413888) itemoff 12427 itemsize 68
extent csum item
item 194 key (EXTENT_CSUM EXTENT_CSUM 250709495808) itemoff 12423 itemsize 4
extent csum item
item 195 key (EXTENT_CSUM EXTENT_CSUM 250709504000) itemoff 12419 itemsize 4
extent csum item
item 196 key (EXTENT_CSUM EXTENT_CSUM 250709512192) itemoff 12403 itemsize 16
extent csum item
item 197 key (EXTENT_CSUM EXTENT_CSUM 250709544960) itemoff 12399 itemsize 4
extent csum item
item 198 key (EXTENT_CSUM EXTENT_CSUM 250709569536) itemoff 12383 itemsize 16
extent csum item
item 199 key (EXTENT_CSUM EXTENT_CSUM 250709594112) itemoff 12371 itemsize 12
extent csum item
item 200 key (EXTENT_CSUM EXTENT_CSUM 250709663744) itemoff 12367 itemsize 4
extent csum item
item 201 key (EXTENT_CSUM EXTENT_CSUM 250709704704) itemoff 12363 itemsize 4
extent csum item
item 202 key (EXTENT_CSUM EXTENT_CSUM 250709848064) itemoff 12355 itemsize 8
extent csum item
item 203 key (EXTENT_CSUM EXTENT_CSUM 250709995520) itemoff 12343 itemsize 12
extent csum item
item 204 key (EXTENT_CSUM EXTENT_CSUM 250710011904) itemoff 12319 itemsize 24
extent csum item
item 205 key (EXTENT_CSUM EXTENT_CSUM 250710126592) itemoff 12243 itemsize 76
extent csum item
item 206 key (EXTENT_CSUM EXTENT_CSUM 250710278144) itemoff 12227 itemsize 16
extent csum item
item 207 key (EXTENT_CSUM EXTENT_CSUM 250710466560) itemoff 12223 itemsize 4
extent csum item
item 208 key (EXTENT_CSUM EXTENT_CSUM 250710593536) itemoff 12219 itemsize 4
extent csum item
item 209 key (EXTENT_CSUM EXTENT_CSUM 250711261184) itemoff 12215 itemsize 4
extent csum item
item 210 key (EXTENT_CSUM EXTENT_CSUM 250711392256) itemoff 12207 itemsize 8
extent csum item
item 211 key (EXTENT_CSUM EXTENT_CSUM 250711490560) itemoff 12199 itemsize 8
extent csum item
item 212 key (EXTENT_CSUM EXTENT_CSUM 250711502848) itemoff 12191 itemsize 8
extent csum item
item 213 key (EXTENT_CSUM EXTENT_CSUM 250711515136) itemoff 12175 itemsize 16
extent csum item
item 214 key (EXTENT_CSUM EXTENT_CSUM 250711547904) itemoff 12167 itemsize 8
extent csum item
item 215 key (EXTENT_CSUM EXTENT_CSUM 250711662592) itemoff 12163 itemsize 4
extent csum item
item 216 key (EXTENT_CSUM EXTENT_CSUM 250711805952) itemoff 12155 itemsize 8
extent csum item
item 217 key (EXTENT_CSUM EXTENT_CSUM 250711941120) itemoff 12143 itemsize 12
extent csum item
item 218 key (EXTENT_CSUM EXTENT_CSUM 250711998464) itemoff 12139 itemsize 4
extent csum item
item 219 key (EXTENT_CSUM EXTENT_CSUM 250712162304) itemoff 12135 itemsize 4
extent csum item
item 220 key (EXTENT_CSUM EXTENT_CSUM 250712170496) itemoff 12099 itemsize 36
extent csum item
item 221 key (EXTENT_CSUM EXTENT_CSUM 250712207360) itemoff 12063 itemsize 36
extent csum item
item 222 key (EXTENT_CSUM EXTENT_CSUM 250712301568) itemoff 11899 itemsize 164
extent csum item
item 223 key (EXTENT_CSUM EXTENT_CSUM 250712481792) itemoff 11883 itemsize 16
extent csum item
item 224 key (EXTENT_CSUM EXTENT_CSUM 250712498176) itemoff 11851 itemsize 32
extent csum item
item 225 key (EXTENT_CSUM EXTENT_CSUM 250712530944) itemoff 11747 itemsize 104
extent csum item
item 226 key (EXTENT_CSUM EXTENT_CSUM 250712637440) itemoff 11707 itemsize 40
extent csum item
item 227 key (EXTENT_CSUM EXTENT_CSUM 250712682496) itemoff 11559 itemsize 148
extent csum item
item 228 key (EXTENT_CSUM EXTENT_CSUM 250712842240) itemoff 11499 itemsize 60
extent csum item
item 229 key (EXTENT_CSUM EXTENT_CSUM 250712920064) itemoff 11427 itemsize 72
extent csum item
item 230 key (EXTENT_CSUM EXTENT_CSUM 250712993792) itemoff 11411 itemsize 16
extent csum item
item 231 key (EXTENT_CSUM EXTENT_CSUM 250713018368) itemoff 11287 itemsize 124
extent csum item
item 232 key (EXTENT_CSUM EXTENT_CSUM 250713186304) itemoff 11275 itemsize 12
extent csum item
item 233 key (EXTENT_CSUM EXTENT_CSUM 250713214976) itemoff 11231 itemsize 44
extent csum item
item 234 key (EXTENT_CSUM EXTENT_CSUM 250713260032) itemoff 11223 itemsize 8
extent csum item
item 235 key (EXTENT_CSUM EXTENT_CSUM 250713300992) itemoff 11163 itemsize 60
extent csum item
item 236 key (EXTENT_CSUM EXTENT_CSUM 250713374720) itemoff 11143 itemsize 20
extent csum item
item 237 key (EXTENT_CSUM EXTENT_CSUM 250713440256) itemoff 11135 itemsize 8
extent csum item
item 238 key (EXTENT_CSUM EXTENT_CSUM 250713591808) itemoff 11131 itemsize 4
extent csum item
item 239 key (EXTENT_CSUM EXTENT_CSUM 250713608192) itemoff 11127 itemsize 4
extent csum item
item 240 key (EXTENT_CSUM EXTENT_CSUM 250713628672) itemoff 11119 itemsize 8
extent csum item
item 241 key (EXTENT_CSUM EXTENT_CSUM 250713653248) itemoff 11115 itemsize 4
extent csum item
item 242 key (EXTENT_CSUM EXTENT_CSUM 250713661440) itemoff 11111 itemsize 4
extent csum item
item 243 key (EXTENT_CSUM EXTENT_CSUM 250713677824) itemoff 11107 itemsize 4
extent csum item
item 244 key (EXTENT_CSUM EXTENT_CSUM 250713681920) itemoff 11103 itemsize 4
extent csum item
item 245 key (EXTENT_CSUM EXTENT_CSUM 250714259456) itemoff 11091 itemsize 12
extent csum item
item 246 key (EXTENT_CSUM EXTENT_CSUM 250714279936) itemoff 11087 itemsize 4
extent csum item
item 247 key (EXTENT_CSUM EXTENT_CSUM 250714308608) itemoff 11039 itemsize 48
extent csum item
item 248 key (EXTENT_CSUM EXTENT_CSUM 250714451968) itemoff 11023 itemsize 16
extent csum item
item 249 key (EXTENT_CSUM EXTENT_CSUM 250714497024) itemoff 10955 itemsize 68
extent csum item
item 250 key (EXTENT_CSUM EXTENT_CSUM 250714628096) itemoff 10951 itemsize 4
extent csum item
item 251 key (EXTENT_CSUM EXTENT_CSUM 250714669056) itemoff 10935 itemsize 16
extent csum item
item 252 key (EXTENT_CSUM EXTENT_CSUM 250714697728) itemoff 10823 itemsize 112
extent csum item
item 253 key (EXTENT_CSUM EXTENT_CSUM 250714894336) itemoff 10819 itemsize 4
extent csum item
item 254 key (EXTENT_CSUM EXTENT_CSUM 250714988544) itemoff 10811 itemsize 8
extent csum item
item 255 key (EXTENT_CSUM EXTENT_CSUM 250715029504) itemoff 10799 itemsize 12
extent csum item
item 256 key (EXTENT_CSUM EXTENT_CSUM 250715058176) itemoff 10787 itemsize 12
extent csum item
item 257 key (EXTENT_CSUM EXTENT_CSUM 250716073984) itemoff 10775 itemsize 12
extent csum item
item 258 key (EXTENT_CSUM EXTENT_CSUM 250717044736) itemoff 10771 itemsize 4
extent csum item
item 259 key (EXTENT_CSUM EXTENT_CSUM 250717081600) itemoff 10763 itemsize 8
extent csum item
item 260 key (EXTENT_CSUM EXTENT_CSUM 250717151232) itemoff 10755 itemsize 8
extent csum item
item 261 key (EXTENT_CSUM EXTENT_CSUM 250717159424) itemoff 10739 itemsize 16
extent csum item
item 262 key (EXTENT_CSUM EXTENT_CSUM 250717175808) itemoff 10731 itemsize 8
extent csum item
item 263 key (EXTENT_CSUM EXTENT_CSUM 250717200384) itemoff 10715 itemsize 16
extent csum item
item 264 key (EXTENT_CSUM EXTENT_CSUM 250717253632) itemoff 10683 itemsize 32
extent csum item
item 265 key (EXTENT_CSUM EXTENT_CSUM 250717396992) itemoff 10675 itemsize 8
extent csum item
item 266 key (EXTENT_CSUM EXTENT_CSUM 250717405184) itemoff 10651 itemsize 24
extent csum item
item 267 key (EXTENT_CSUM EXTENT_CSUM 250717458432) itemoff 10635 itemsize 16
extent csum item
item 268 key (EXTENT_CSUM EXTENT_CSUM 250717540352) itemoff 10555 itemsize 80
extent csum item
item 269 key (EXTENT_CSUM EXTENT_CSUM 250717622272) itemoff 10543 itemsize 12
extent csum item
item 270 key (EXTENT_CSUM EXTENT_CSUM 250717634560) itemoff 10479 itemsize 64
extent csum item
item 271 key (EXTENT_CSUM EXTENT_CSUM 250717700096) itemoff 10463 itemsize 16
extent csum item
item 272 key (EXTENT_CSUM EXTENT_CSUM 250717716480) itemoff 10431 itemsize 32
extent csum item
item 273 key (EXTENT_CSUM EXTENT_CSUM 250717749248) itemoff 10407 itemsize 24
extent csum item
item 274 key (EXTENT_CSUM EXTENT_CSUM 250717798400) itemoff 10395 itemsize 12
extent csum item
item 275 key (EXTENT_CSUM EXTENT_CSUM 250717810688) itemoff 10391 itemsize 4
extent csum item
item 276 key (EXTENT_CSUM EXTENT_CSUM 250717831168) itemoff 10387 itemsize 4
extent csum item
item 277 key (EXTENT_CSUM EXTENT_CSUM 250717896704) itemoff 10383 itemsize 4
extent csum item
item 278 key (EXTENT_CSUM EXTENT_CSUM 250717986816) itemoff 10371 itemsize 12
extent csum item
item 279 key (EXTENT_CSUM EXTENT_CSUM 250718044160) itemoff 10355 itemsize 16
extent csum item
item 280 key (EXTENT_CSUM EXTENT_CSUM 250718142464) itemoff 10351 itemsize 4
extent csum item
item 281 key (EXTENT_CSUM EXTENT_CSUM 250718146560) itemoff 10343 itemsize 8
extent csum item
item 282 key (EXTENT_CSUM EXTENT_CSUM 250718179328) itemoff 10319 itemsize 24
extent csum item
item 283 key (EXTENT_CSUM EXTENT_CSUM 250718224384) itemoff 10315 itemsize 4
extent csum item
item 284 key (EXTENT_CSUM EXTENT_CSUM 250718244864) itemoff 10307 itemsize 8
extent csum item
item 285 key (EXTENT_CSUM EXTENT_CSUM 250718253056) itemoff 10299 itemsize 8
extent csum item
item 286 key (EXTENT_CSUM EXTENT_CSUM 250718400512) itemoff 10291 itemsize 8
extent csum item
item 287 key (EXTENT_CSUM EXTENT_CSUM 250718416896) itemoff 10279 itemsize 12
extent csum item
item 288 key (EXTENT_CSUM EXTENT_CSUM 250718490624) itemoff 10275 itemsize 4
extent csum item
item 289 key (EXTENT_CSUM EXTENT_CSUM 250718605312) itemoff 10263 itemsize 12
extent csum item
item 290 key (EXTENT_CSUM EXTENT_CSUM 250718666752) itemoff 10239 itemsize 24
extent csum item
item 291 key (EXTENT_CSUM EXTENT_CSUM 250718822400) itemoff 10235 itemsize 4
extent csum item
item 292 key (EXTENT_CSUM EXTENT_CSUM 250718826496) itemoff 10231 itemsize 4
extent csum item
item 293 key (18446744073709551350 EXTENT_CSUM 250718830592) itemoff
10207 itemsize 24
extent csum item
item 294 key (EXTENT_CSUM EXTENT_CSUM 250719469568) itemoff 10203 itemsize 4
extent csum item
item 295 key (EXTENT_CSUM EXTENT_CSUM 250719551488) itemoff 10195 itemsize 8
extent csum item
item 296 key (EXTENT_CSUM EXTENT_CSUM 250719592448) itemoff 10191 itemsize 4
extent csum item
item 297 key (EXTENT_CSUM EXTENT_CSUM 250719617024) itemoff 10187 itemsize 4
extent csum item
item 298 key (EXTENT_CSUM EXTENT_CSUM 250719637504) itemoff 10183 itemsize 4
extent csum item
item 299 key (EXTENT_CSUM EXTENT_CSUM 250719674368) itemoff 10179 itemsize 4
extent csum item
item 300 key (EXTENT_CSUM EXTENT_CSUM 250719678464) itemoff 10171 itemsize 8
extent csum item
item 301 key (EXTENT_CSUM EXTENT_CSUM 250719707136) itemoff 10167 itemsize 4
extent csum item
item 302 key (EXTENT_CSUM EXTENT_CSUM 250719735808) itemoff 10163 itemsize 4
extent csum item
item 303 key (EXTENT_CSUM EXTENT_CSUM 250719862784) itemoff 10155 itemsize 8
extent csum item
item 304 key (EXTENT_CSUM EXTENT_CSUM 250719875072) itemoff 9963 itemsize 192
extent csum item
item 305 key (EXTENT_CSUM EXTENT_CSUM 250720260096) itemoff 9899 itemsize 64
extent csum item
item 306 key (EXTENT_CSUM EXTENT_CSUM 250720346112) itemoff 9839 itemsize 60
extent csum item
item 307 key (EXTENT_CSUM EXTENT_CSUM 250720423936) itemoff 9719 itemsize 120
extent csum item
item 308 key (EXTENT_CSUM EXTENT_CSUM 250720579584) itemoff 9691 itemsize 28
extent csum item
item 309 key (EXTENT_CSUM EXTENT_CSUM 250720661504) itemoff 9687 itemsize 4
extent csum item
item 310 key (EXTENT_CSUM EXTENT_CSUM 250720702464) itemoff 9683 itemsize 4
extent csum item
item 311 key (EXTENT_CSUM EXTENT_CSUM 250720739328) itemoff 9679 itemsize 4
extent csum item
item 312 key (EXTENT_CSUM EXTENT_CSUM 250720858112) itemoff 9659 itemsize 20
extent csum item
item 313 key (EXTENT_CSUM EXTENT_CSUM 250720878592) itemoff 9655 itemsize 4
extent csum item
item 314 key (EXTENT_CSUM EXTENT_CSUM 250720882688) itemoff 9651 itemsize 4
extent csum item
item 315 key (EXTENT_CSUM EXTENT_CSUM 250720935936) itemoff 9647 itemsize 4
extent csum item
item 316 key (EXTENT_CSUM EXTENT_CSUM 250721030144) itemoff 9623 itemsize 24
extent csum item
item 317 key (EXTENT_CSUM EXTENT_CSUM 250721058816) itemoff 9615 itemsize 8
extent csum item
item 318 key (EXTENT_CSUM EXTENT_CSUM 250721075200) itemoff 9591 itemsize 24
extent csum item
item 319 key (EXTENT_CSUM EXTENT_CSUM 250721148928) itemoff 9587 itemsize 4
extent csum item
item 320 key (EXTENT_CSUM EXTENT_CSUM 250722041856) itemoff 9559 itemsize 28
extent csum item
item 321 key (EXTENT_CSUM EXTENT_CSUM 250722078720) itemoff 9555 itemsize 4
extent csum item
item 322 key (EXTENT_CSUM EXTENT_CSUM 250722086912) itemoff 9551 itemsize 4
extent csum item
item 323 key (EXTENT_CSUM EXTENT_CSUM 250722095104) itemoff 9543 itemsize 8
extent csum item
item 324 key (EXTENT_CSUM EXTENT_CSUM 250722136064) itemoff 9539 itemsize 4
extent csum item
item 325 key (EXTENT_CSUM EXTENT_CSUM 250722164736) itemoff 9511 itemsize 28
extent csum item
item 326 key (EXTENT_CSUM EXTENT_CSUM 250722287616) itemoff 9503 itemsize 8
extent csum item
item 327 key (EXTENT_CSUM EXTENT_CSUM 250722299904) itemoff 9495 itemsize 8
extent csum item
item 328 key (EXTENT_CSUM EXTENT_CSUM 250722316288) itemoff 9487 itemsize 8
extent csum item
item 329 key (EXTENT_CSUM EXTENT_CSUM 250722324480) itemoff 9479 itemsize 8
extent csum item
item 330 key (EXTENT_CSUM EXTENT_CSUM 250722349056) itemoff 9431 itemsize 48
extent csum item
item 331 key (EXTENT_CSUM EXTENT_CSUM 250722455552) itemoff 9427 itemsize 4
extent csum item
item 332 key (EXTENT_CSUM EXTENT_CSUM 250722603008) itemoff 9419 itemsize 8
extent csum item
item 333 key (EXTENT_CSUM EXTENT_CSUM 250722615296) itemoff 9375 itemsize 44
extent csum item
item 334 key (EXTENT_CSUM EXTENT_CSUM 250722709504) itemoff 9359 itemsize 16
extent csum item
item 335 key (EXTENT_CSUM EXTENT_CSUM 250722758656) itemoff 9323 itemsize 36
extent csum item
item 336 key (EXTENT_CSUM EXTENT_CSUM 250723299328) itemoff 9319 itemsize 4
extent csum item
item 337 key (EXTENT_CSUM EXTENT_CSUM 250723360768) itemoff 9315 itemsize 4
extent csum item
item 338 key (EXTENT_CSUM EXTENT_CSUM 250723528704) itemoff 9307 itemsize 8
extent csum item
item 339 key (EXTENT_CSUM EXTENT_CSUM 250723598336) itemoff 9303 itemsize 4
extent csum item
item 340 key (EXTENT_CSUM EXTENT_CSUM 250723622912) itemoff 9299 itemsize 4
extent csum item
item 341 key (EXTENT_CSUM EXTENT_CSUM 250723672064) itemoff 9295 itemsize 4
extent csum item
item 342 key (EXTENT_CSUM EXTENT_CSUM 250723721216) itemoff 9271 itemsize 24
extent csum item
item 343 key (EXTENT_CSUM EXTENT_CSUM 250723745792) itemoff 9263 itemsize 8
extent csum item
item 344 key (EXTENT_CSUM EXTENT_CSUM 250723753984) itemoff 9247 itemsize 16
extent csum item
item 345 key (EXTENT_CSUM EXTENT_CSUM 250723770368) itemoff 9219 itemsize 28
extent csum item
item 346 key (EXTENT_CSUM EXTENT_CSUM 250723799040) itemoff 9211 itemsize 8
extent csum item
item 347 key (EXTENT_CSUM EXTENT_CSUM 250723807232) itemoff 9207 itemsize 4
extent csum item
item 348 key (EXTENT_CSUM EXTENT_CSUM 250723811328) itemoff 9179 itemsize 28
extent csum item
item 349 key (EXTENT_CSUM EXTENT_CSUM 250723840000) itemoff 9167 itemsize 12
extent csum item
item 350 key (EXTENT_CSUM EXTENT_CSUM 250723852288) itemoff 9159 itemsize 8
extent csum item
item 351 key (EXTENT_CSUM EXTENT_CSUM 250723860480) itemoff 9147 itemsize 12
extent csum item
item 352 key (EXTENT_CSUM EXTENT_CSUM 250723872768) itemoff 9135 itemsize 12
extent csum item
item 353 key (EXTENT_CSUM EXTENT_CSUM 250723885056) itemoff 9127 itemsize 8
extent csum item
item 354 key (EXTENT_CSUM EXTENT_CSUM 250723893248) itemoff 9123 itemsize 4
extent csum item
item 355 key (EXTENT_CSUM EXTENT_CSUM 250723897344) itemoff 9111 itemsize 12
extent csum item
item 356 key (EXTENT_CSUM EXTENT_CSUM 250723909632) itemoff 9095 itemsize 16
extent csum item
item 357 key (EXTENT_CSUM EXTENT_CSUM 250723926016) itemoff 9075 itemsize 20
extent csum item
item 358 key (EXTENT_CSUM EXTENT_CSUM 250723946496) itemoff 9067 itemsize 8
extent csum item
item 359 key (EXTENT_CSUM EXTENT_CSUM 250723954688) itemoff 9055 itemsize 12
extent csum item
item 360 key (EXTENT_CSUM EXTENT_CSUM 250723971072) itemoff 9031 itemsize 24
extent csum item


On Sun, Dec 27, 2015 at 8:03 PM, james harvey <jamespharvey20@gmail.com> wrote:
> Have gotten about 300 (mostly duplicate) BTRFS errors in the last
> hours.  No signs of disk problem.  Non-SSD SATA.  Was able to dd the
> drive into an image file on another drive without errors.  Smartctl
> reports no issues.  It is a single disk though.
>
> Been running btrfs fine since 7/9/15, installing arch linux with linux
> 4.0.7-2 and btrfs-progs 4.1-1.
>
> Now running linux 4.2.5-1 (installed 10/27, 4.3 isn't in arch core
> repo yet) and btrfs-progs 4.3.1-2 (installed 11/24.)
>
> corrupt leaf, bad key order
> ====================
>
> 219 of these lines.  All duplicates.
>
> [ 836.639911] BTRFS critical (device sda2): corrupt leaf, bad key
> order: block=241468833792,root=1, slot=292
>
> no csum found / csum failed
> =====================
>
> After two of those corrupt lead criticals, have gotten 82 of these
> lines.  More of the corrupt leaf criticals between these.  Mostly
> duplicates, 5 unique inodes given.  All of these files happen to be
> .cache/chromium/Default/Cache/data_* files and
> .local/share/baloo/index, which makes sense because that's mostly what
> this machine is used for.
>
> [ 836.640132] BTRFS info (device sda2): no csum found for inode
> 1809716 start 8011776
> [ 836.644547] BTRFS warning (device sda2): csum failed ino 1809716 off
> 8011776 csum 571345089 expected csum 0
>
> Input/output error
> =============
>
> Started to run a "btrfs scrub start -B -r /dev/sda2" (didn't see the
> messages above on the list recently, so wasn't going to write changes
> until I had made a dd disk image on another drive.  Got:
>
> ERROR: scrubbing /dev/sda2 failed for device id 1: ret=-1, errno=5
> (Input/output error)
> scrub canceled for 535e3d41-989e-4c14-a837-536d79e4ff51
> scrub started at Sun Dec 27 18:33:31 2015 and was aborted after 00:18:22
> total bytes scrubbed: 156.31GiB with 0 errors
>
> dmesg doesn't show any entries saying something like input/output
> error, just the corrupt leaf bad key order, no csum found csum failed
> errors.
>
> sda2 is what I'm booted off of, and I'm still running the system
> without rebooting, typing this email on it, so the drive didn't stop
> being usable after btrfs scrub reported an Input/output error, and
> isn't giving more issues besides the above errors.
>
>
> Obviously looking for comments on all of this, but most interested in
> if the corrupt leaf, bad key order message risks a bunch of files or
> not.  Familiar with leafs as a computing term, but don't even know
> what they are in the context of btrfs.  If it's a single file, how do
> I use the corrupt leaf, bad key order block number to see what it
> corresponds to, like I did with btrfs inspect-internal with the
> inodes?
